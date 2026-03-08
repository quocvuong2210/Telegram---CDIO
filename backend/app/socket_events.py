from flask_socketio import emit, join_room, leave_room
from . import socketio, db
from .models import Message, Notification

@socketio.on('join_chat')
def handle_join_chat(data):
    chat_id = data.get('chat_id')
    if chat_id:
        join_room(str(chat_id))
        print(f"User joined chat {chat_id}")

@socketio.on('leave_chat')
def handle_leave_chat(data):
    chat_id = data.get('chat_id')
    if chat_id:
        leave_room(str(chat_id))
        print(f"User left chat {chat_id}")

@socketio.on('send_message')
def handle_send_message(data):
    chat_id = data.get('chat_id')
    sender_id = data.get('sender_id')
    content = data.get('content')

    if not chat_id or not sender_id or not content:
        emit('error', {'message': 'Invalid message data'})
        return

    try:
        message = Message(chat_id=chat_id, sender_id=sender_id, content=content)
        db.session.add(message)
        db.session.commit()

        # Calculate recipient ID from chat_id and sender_id
        # chat_id = min(user1, user2) * 1000000 + max(user1, user2)
        min_user = chat_id // 1000000
        max_user = chat_id % 1000000
        recipient_id = max_user if sender_id == min_user else min_user

        # Create notification for the recipient
        notification = Notification(user_id=recipient_id, message_id=message.id)
        db.session.add(notification)
        db.session.commit()

        message_data = message.to_dict()
        emit('new_message', message_data, room=str(chat_id))

        # Emit notification event to the recipient (if they're connected)
        emit('new_notification', {
            'id': notification.id,
            'user_id': recipient_id,
            'message_id': message.id,
            'sender_id': sender_id,
            'content': content,
            'is_read': False,
            'created_at': notification.created_at.isoformat()
        }, to=str(recipient_id))

        print(f"Message sent in chat {chat_id}: {content}")
        print(f"Notification created for user {recipient_id}")
    except Exception as e:
        db.session.rollback()
        emit('error', {'message': str(e)})
        print(f"Error sending message: {e}")


@socketio.on('mark_as_read')
def handle_mark_as_read(data):
    """Handle marking a message as read"""
    message_id = data.get('message_id')
    chat_id = data.get('chat_id')
    
    if not message_id:
        emit('error', {'message': 'message_id is required'})
        return
    
    try:
        message = Message.query.get(message_id)
        if message:
            message.is_read = True
            db.session.commit()
            
            # Broadcast read receipt to all users in the chat
            emit('message_read', {
                'message_id': message_id,
                'chat_id': chat_id,
                'is_read': True
            }, room=str(chat_id) if chat_id else None)
            
            print(f"Message {message_id} marked as read")
    except Exception as e:
        db.session.rollback()
        emit('error', {'message': str(e)})
        print(f"Error marking message as read: {e}")


@socketio.on('mark_all_as_read')
def handle_mark_all_as_read(data):
    """Handle marking all messages in a chat as read"""
    chat_id = data.get('chat_id')
    
    if not chat_id:
        emit('error', {'message': 'chat_id is required'})
        return
    
    try:
        messages = Message.query.filter_by(chat_id=chat_id).all()
        for message in messages:
            message.is_read = True
        db.session.commit()
        
        # Broadcast to all users in the chat
        emit('all_messages_read', {
            'chat_id': chat_id,
            'count': len(messages)
        }, room=str(chat_id))
        
        print(f"All messages in chat {chat_id} marked as read")
    except Exception as e:
        db.session.rollback()
        emit('error', {'message': str(e)})
        print(f"Error marking all messages as read: {e}")


@socketio.on('register_user')
def handle_register_user(data):
    """Register user to receive personal notifications"""
    user_id = data.get('user_id')
    if user_id:
        join_room(str(user_id))
        print(f"User {user_id} registered for notifications")


@socketio.on('mark_notification_as_read')
def handle_mark_notification_as_read(data):
    """Mark a notification as read"""
    notification_id = data.get('notification_id')
    
    if not notification_id:
        emit('error', {'message': 'notification_id is required'})
        return
    
    try:
        notification = Notification.query.get(notification_id)
        if notification:
            notification.is_read = True
            db.session.commit()
            
            # Emit event to confirm
            emit('notification_read', {
                'notification_id': notification_id,
                'is_read': True
            })
            
            print(f"Notification {notification_id} marked as read")
        else:
            emit('error', {'message': 'Notification not found'})
    except Exception as e:
        db.session.rollback()
        emit('error', {'message': str(e)})
        print(f"Error marking notification as read: {e}")
