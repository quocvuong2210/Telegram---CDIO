import { useState, useEffect, useRef } from 'react'
import { useAuth } from '../contexts/AuthContext'
import ProfileMenu from './ProfileMenu'
import SearchBar from './SearchBar'
import io from 'socket.io-client'

const API_BASE_URL = 'http://127.0.0.1:5000'

export default function ChatInterface() {
  const { user, logout } = useAuth()
  const [chats, setChats] = useState([])
  const [selectedChat, setSelectedChat] = useState(null)
  const [messages, setMessages] = useState([])
  const [newMessage, setNewMessage] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  const [currentUser, setCurrentUser] = useState(user)
  const messagesEndRef = useRef(null)
  const socketRef = useRef(null)
  const [chatLastMessages, setChatLastMessages] = useState({})
  const [unreadCounts, setUnreadCounts] = useState({})
  const [notifications, setNotifications] = useState({}) // notifications keyed by sender_id

  // whenever the authenticated user changes we need to reload both
  // the currentUser object and the list of contact-based chats.  the
  // old version of this component was hard‑coding three demo chats which
  // is what you saw in the screenshot; remove that and call the real
  // backend instead.
  useEffect(() => {
    console.log('DEBUG: ChatInterface mounted with user:', user)
    setCurrentUser(user)
    if (user && user.id) {
      fetchContacts()
      // Connect to socket
      socketRef.current = io(API_BASE_URL)
      
      // Register user to receive notifications
      socketRef.current.emit('register_user', { user_id: user.id })
      
      socketRef.current.on('new_message', (message) => {
        setMessages(prev => [...prev, message])
        // Update last message for the chat
        updateLastMessage(message.chat_id, message)
        // Increase unread count for the contact if not in current chat
        if (selectedChat && message.chat_id !== chatIdFor(user.id, selectedChat.id)) {
          setUnreadCounts(prev => ({
            ...prev,
            [message.chat_id]: (prev[message.chat_id] || 0) + 1
          }))
        }
      })
      
      // Listen for new notifications
      socketRef.current.on('new_notification', (notification) => {
        console.log('DEBUG: Received notification:', notification)
        setNotifications(prev => ({
          ...prev,
          [notification.sender_id]: (prev[notification.sender_id] || []).concat(notification)
        }))
      })
      
      socketRef.current.on('message_read', (data) => {
        // Update message read status
        setMessages(prev => prev.map(msg => 
          msg.id === data.message_id ? { ...msg, is_read: true } : msg
        ))
      })
      socketRef.current.on('all_messages_read', (data) => {
        // Mark all messages in chat as read
        setMessages(prev => prev.map(msg => 
          msg.chat_id === data.chat_id ? { ...msg, is_read: true } : msg
        ))
      })
      socketRef.current.on('error', (error) => {
        console.error('Socket error:', error)
      })
    } else {
      // clear when nobody is logged in
      setChats([])
      setSelectedChat(null)
      setMessages([])
      if (socketRef.current) {
        socketRef.current.disconnect()
        socketRef.current = null
      }
    }

    return () => {
      if (socketRef.current) {
        socketRef.current.disconnect()
      }
    }
  }, [user])

  // compute a stable numeric id for a conversation between two user ids
  const chatIdFor = (userId, otherId) => {
    if (!userId || !otherId) return null
    const a = Math.min(userId, otherId)
    const b = Math.max(userId, otherId)
    return a * 1000000 + b
  }

  const updateLastMessage = (chatId, message) => {
    setChatLastMessages(prev => ({
      ...prev,
      [chatId]: message
    }))
  }

  const fetchMessages = async (chatId) => {
    if (!chatId) {
      console.error('ERROR: chatId is missing')
      return
    }
    
    setIsLoading(true)
    try {
      console.log(`DEBUG: Fetching messages for chat_id: ${chatId}`)
      const response = await fetch(`${API_BASE_URL}/api/messages/${chatId}`)
      const data = await response.json()
      
      if (response.ok) {
        console.log('DEBUG: Messages fetched successfully:', data)
        setMessages(data)
        // Mark all messages as read when opening the chat
        if (data.length > 0) {
          socketRef.current?.emit('mark_all_as_read', { chat_id: chatId })
          setUnreadCounts(prev => ({
            ...prev,
            [chatId]: 0
          }))
        }
      } else {
        console.error('ERROR: Failed to fetch messages:', data)
        setMessages([])
      }
    } catch (error) {
      console.error('ERROR: Exception fetching messages:', error)
      setMessages([])
    }
    setIsLoading(false)
  }

  const sendMessage = async () => {
    if (!newMessage.trim() || !selectedChat || !socketRef.current) return

    console.log('DEBUG: User object:', user)
    const computedChat = chatIdFor(user.id, selectedChat.id)
    console.log('DEBUG: Sending message', { chat_id: computedChat, sender_id: user?.id, content: newMessage })

    if (!user || !user.id) {
      console.error('ERROR: User or user.id is missing', user)
      alert('Error: User ID not found. Please login again.')
      return
    }

    const payload = {
      chat_id: computedChat,
      sender_id: user.id,
      content: newMessage.trim(),
    }

    socketRef.current.emit('send_message', payload)
    setNewMessage('')
  }

  const handleChatSelect = (chat) => {
    setSelectedChat(chat)
    const computed = chatIdFor(user?.id, chat.id)
    fetchMessages(computed)
    // Join chat room
    if (socketRef.current) {
      socketRef.current.emit('join_chat', { chat_id: computed })
    }
    
    // Mark notifications from this sender as read
    if (notifications[chat.id] && notifications[chat.id].length > 0) {
      notifications[chat.id].forEach(notif => {
        if (!notif.is_read) {
          socketRef.current?.emit('mark_notification_as_read', { notification_id: notif.id })
        }
      })
      // Clear notifications from this sender
      setNotifications(prev => ({
        ...prev,
        [chat.id]: []
      }))
    }
  }

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }

  useEffect(() => {
    scrollToBottom()
  }, [messages])


  // utility to load contacts from backend and adapt to "chat" shape
  const fetchContacts = async () => {
    if (!user || !user.id) return

    try {
      const token = localStorage.getItem('access_token')
      const res = await fetch(`${API_BASE_URL}/api/contacts`, {
        headers: { Authorization: `Bearer ${token}` }
      })
      if (!res.ok) {
        console.error('Failed to load contacts', await res.text())
        return
      }
      const data = await res.json()
      // each contact contains `user` object representing the friend
      const newChats = data.contacts.map(c => ({
        id: c.user.id,
        name: c.user.username || c.user.name || 'Unknown',
        lastMessage: '' // could be filled by another endpoint later
      }))
      console.log('DEBUG: loaded contacts -> chats', newChats)
      setChats(newChats)
      
      // Fetch last message for each chat
      for (const chat of newChats) {
        const chatId = chatIdFor(user.id, chat.id)
        try {
          const lastMsgRes = await fetch(`${API_BASE_URL}/api/messages/${chatId}/latest`)
          const lastMsg = await lastMsgRes.json()
          if (lastMsg) {
            setChatLastMessages(prev => ({
              ...prev,
              [chatId]: lastMsg
            }))
          }
        } catch (err) {
          console.error(`Error fetching last message for chat ${chatId}:`, err)
        }
      }
    } catch (err) {
      console.error('Error fetching contacts', err)
    }
  }

  // callback from SearchBar when a contact is added; just refresh list
  const handleContactAdded = () => {
    fetchContacts()
  }

  const getLastMessagePreview = (chat) => {
    const chatId = chatIdFor(user?.id, chat.id)
    const lastMsg = chatLastMessages[chatId]
    
    if (!lastMsg) return ''
    
    // Show preview with read status indicator
    const preview = lastMsg.content.substring(0, 30)
    const isOwn = lastMsg.sender_id === user?.id
    const statusIcon = lastMsg.is_read ? '✓✓' : '✓'
    
    return isOwn ? `${preview}... ${statusIcon}` : preview
  }

  const getUnreadBadge = (chat) => {
    const chatId = chatIdFor(user?.id, chat.id)
    const unreadCount = unreadCounts[chatId] || 0
    return unreadCount > 0 ? unreadCount : null
  }

  const getNotificationCount = (chat) => {
    // Get count of unread notifications from this sender
    const senderNotifications = notifications[chat.id] || []
    return senderNotifications.length > 0 ? senderNotifications.length : null
  }

  const getNotificationPreview = (chat) => {
    // Get the first unread notification text from this sender
    const senderNotifications = notifications[chat.id] || []
    if (senderNotifications.length === 0) return ''
    return senderNotifications[0].content.substring(0, 30) + '...'
  }

  return (
    <div className="chat-container">
      <div className="chat-sidebar">
        <div className="chat-header">
          <h2>Telegram</h2>
          <ProfileMenu 
            user={currentUser}
            onLogout={logout}
            onProfileUpdate={(updatedUser) => setCurrentUser(updatedUser)}
          />
        </div>
        
        <div className="chat-search-container">
          <SearchBar 
            currentUser={currentUser}
            onContactAdded={handleContactAdded}
          />
        </div>

        <div className="chat-list">
          {chats.map(chat => (
            <div
              key={chat.id}
              className={`chat-item ${selectedChat?.id === chat.id ? 'active' : ''} ${getNotificationCount(chat) ? 'has-notification' : ''}`}
              onClick={() => handleChatSelect(chat)}
            >
              <div className="chat-avatar">{chat.name[0]}</div>
              <div className="chat-info">
                <div className="chat-name">{chat.name}</div>
                {getNotificationCount(chat) ? (
                  <div className="chat-notification" style={{color: '#ff6b6b', fontWeight: 'bold'}}>
                    🔔 {getNotificationPreview(chat)}
                  </div>
                ) : (
                  <div className="chat-last-message">{getLastMessagePreview(chat)}</div>
                )}
              </div>
              {getNotificationCount(chat) && (
                <div className="notification-badge" style={{backgroundColor: '#ff6b6b'}}>
                  {getNotificationCount(chat)}
                </div>
              )}
              {getUnreadBadge(chat) && !getNotificationCount(chat) && (
                <div className="unread-badge">{getUnreadBadge(chat)}</div>
              )}
            </div>
          ))}
        </div>
      </div>

      <div className="chat-main">
        {selectedChat ? (
          <>
            <div className="chat-messages-header">
              <div className="chat-avatar">{selectedChat.name[0]}</div>
              <div className="chat-info">
                <div className="chat-name">{selectedChat.name}</div>
              </div>
            </div>

            <div className="chat-messages">
              {isLoading ? (
                <div className="loading">Loading messages...</div>
              ) : (
                messages.map(message => (
                  <div
                    key={message.id}
                    className={`message ${message.sender_id === user.id ? 'own' : 'other'}`}
                  >
                    <div className="message-content">{message.content}</div>
                    <div className="message-time">
                      {new Date(message.created_at).toLocaleTimeString()}
                      {message.sender_id === user.id && (
                        <span className="read-status">{message.is_read ? '✓✓' : '✓'}</span>
                      )}
                    </div>
                  </div>
                ))
              )}
              <div ref={messagesEndRef} />
            </div>

            <div className="chat-input">
              <input
                type="text"
                value={newMessage}
                onChange={(e) => setNewMessage(e.target.value)}
                onKeyPress={(e) => e.key === 'Enter' && sendMessage()}
                placeholder="Type a message..."
                className="message-input"
              />
              <button onClick={sendMessage} className="send-btn">Send</button>
            </div>
          </>
        ) : (
          <div className="no-chat-selected">
            <h3>Select a chat to start messaging</h3>
          </div>
        )}
      </div>
    </div>
  )
}