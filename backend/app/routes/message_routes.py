from flask import Blueprint, jsonify, request
from werkzeug.exceptions import BadRequest, NotFound
from sqlalchemy.exc import IntegrityError

from .. import db
from ..models import Message, User, Notification

message_bp = Blueprint("messages", __name__)


@message_bp.route("/messages", methods=["POST"])
def send_message():
    data = request.get_json() or {}
    chat_id = data.get("chat_id")
    sender_id = data.get("sender_id")
    content = data.get("content")

    print(f"DEBUG: Received message - chat_id={chat_id}, sender_id={sender_id}, content={content}")

    if not chat_id or not sender_id or not content:
        raise BadRequest("chat_id, sender_id, and content are required")

    # Verify sender exists
    sender = User.query.get(sender_id)
    if not sender:
        raise BadRequest(f"Sender with ID {sender_id} does not exist")

    try:
        message = Message(chat_id=chat_id, sender_id=sender_id, content=content)
        db.session.add(message)
        db.session.commit()
        print(f"DEBUG: Message created successfully - id={message.id}")

        # Calculate recipient ID from chat_id and sender_id
        # chat_id = min(user1, user2) * 1000000 + max(user1, user2)
        min_user = chat_id // 1000000
        max_user = chat_id % 1000000
        recipient_id = max_user if sender_id == min_user else min_user

        # Create notification for the recipient
        notification = Notification(user_id=recipient_id, message_id=message.id)
        db.session.add(notification)
        db.session.commit()

        return jsonify(message.to_dict()), 201
    except IntegrityError as e:
        db.session.rollback()
        print(f"ERROR: Database integrity error - {str(e)}")
        raise BadRequest(f"Database error: {str(e)}")
    except Exception as e:
        db.session.rollback()
        print(f"ERROR: Unexpected error - {str(e)}")
        raise BadRequest(f"Error sending message: {str(e)}")


@message_bp.route("/messages/<int:chat_id>", methods=["GET"])
def get_messages(chat_id):
    messages = Message.query.filter_by(chat_id=chat_id).order_by(Message.created_at).all()
    return jsonify([msg.to_dict() for msg in messages]), 200


@message_bp.route("/messages/<int:message_id>/read", methods=["PUT"])
def mark_message_read(message_id):
    """Mark a specific message as read"""
    message = Message.query.get(message_id)
    if not message:
        raise NotFound(f"Message with ID {message_id} not found")
    
    message.is_read = True
    db.session.commit()
    return jsonify(message.to_dict()), 200


@message_bp.route("/messages/<int:chat_id>/mark-all-read", methods=["PUT"])
def mark_all_messages_read(chat_id):
    """Mark all messages in a chat as read"""
    messages = Message.query.filter_by(chat_id=chat_id).all()
    for message in messages:
        message.is_read = True
    db.session.commit()
    return jsonify({"status": "success", "count": len(messages)}), 200


@message_bp.route("/messages/<int:chat_id>/latest", methods=["GET"])
def get_latest_message(chat_id):
    """Get the latest message in a chat"""
    message = Message.query.filter_by(chat_id=chat_id).order_by(Message.created_at.desc()).first()
    if not message:
        return jsonify(None), 200
    return jsonify(message.to_dict()), 200