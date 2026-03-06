from flask import Blueprint, jsonify, request
from werkzeug.exceptions import BadRequest, NotFound
from sqlalchemy.exc import IntegrityError

from .. import db
from ..models import Message, User

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