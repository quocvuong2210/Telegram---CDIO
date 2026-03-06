import { useState, useEffect, useRef } from 'react'
import { useAuth } from '../contexts/AuthContext'

const API_BASE_URL = 'http://127.0.0.1:5000'

export default function ChatInterface() {
  const { user, logout } = useAuth()
  const [chats, setChats] = useState([])
  const [selectedChat, setSelectedChat] = useState(null)
  const [messages, setMessages] = useState([])
  const [newMessage, setNewMessage] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  const messagesEndRef = useRef(null)

  // For demo, create some sample chats
  useEffect(() => {
    console.log('DEBUG: ChatInterface mounted with user:', user)
    setChats([
      { id: 1, name: 'Group Chat 1', lastMessage: 'Hello everyone!' },
      { id: 2, name: 'John Doe', lastMessage: 'See you later' },
      { id: 3, name: 'Jane Smith', lastMessage: 'Thanks!' },
    ])
  }, [])

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
    if (!newMessage.trim() || !selectedChat) return

    console.log('DEBUG: User object:', user)
    console.log('DEBUG: Sending message', { chat_id: selectedChat.id, sender_id: user?.id, content: newMessage })

    if (!user || !user.id) {
      console.error('ERROR: User or user.id is missing', user)
      alert('Error: User ID not found. Please login again.')
      return
    }

    try {
      const payload = {
        chat_id: selectedChat.id,
        sender_id: user.id,
        content: newMessage.trim(),
      }
      console.log('DEBUG: Sending payload:', payload)
      
      const response = await fetch(`${API_BASE_URL}/api/messages`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      })

      let responseData
      try {
        responseData = await response.json()
      } catch (parseError) {
        console.error('ERROR: Failed to parse response JSON:', parseError)
        console.error('Response status:', response.status)
        console.error('Response text:', await response.text())
        alert('Server error: Invalid response format')
        return
      }

      console.log('Response from server:', { status: response.status, data: responseData })

      if (response.ok) {
        console.log('DEBUG: Message sent successfully')
        setMessages(prev => [...prev, responseData])
        setNewMessage('')
      } else {
        console.error('Error response:', responseData)
        alert(`Failed to send message: ${responseData.error || 'Unknown error'}`)
      }
    } catch (error) {
      console.error('Error sending message:', error)
      alert(`Error: ${error.message}`)
    }
  }

  const handleChatSelect = (chat) => {
    setSelectedChat(chat)
    fetchMessages(chat.id)
  }

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }

  useEffect(() => {
    scrollToBottom()
  }, [messages])

  return (
    <div className="chat-container">
      <div className="chat-sidebar">
        <div className="chat-header">
          <h2>Telegram</h2>
          <button onClick={logout} className="logout-btn">Logout</button>
        </div>
        <div className="chat-list">
          {chats.map(chat => (
            <div
              key={chat.id}
              className={`chat-item ${selectedChat?.id === chat.id ? 'active' : ''}`}
              onClick={() => handleChatSelect(chat)}
            >
              <div className="chat-avatar">{chat.name[0]}</div>
              <div className="chat-info">
                <div className="chat-name">{chat.name}</div>
                <div className="chat-last-message">{chat.lastMessage}</div>
              </div>
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