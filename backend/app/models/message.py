from datetime import datetime

from .. import db


class Message(db.Model):
    __tablename__ = "messages"

    id = db.Column(db.BigInteger, primary_key=True, autoincrement=True)
    chat_id = db.Column(db.BigInteger, nullable=False, index=True)  # No FK constraint - just conversation ID
    sender_id = db.Column(db.BigInteger, db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False, index=True)
    content = db.Column(db.Text, nullable=True)
    message_type = db.Column(db.String(50), nullable=True, default='text')  # text, image, video, file, audio
    reply_to = db.Column(db.BigInteger, nullable=True, index=True)  # ID of the message being replied to
    is_edited = db.Column(db.Boolean, nullable=True, default=False)
    is_read = db.Column(db.Boolean, nullable=False, default=False)  # Track if message has been read
    created_at = db.Column(db.DateTime, nullable=True, server_default=db.func.current_timestamp())
    updated_at = db.Column(db.DateTime, nullable=True, server_default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "chat_id": self.chat_id,
            "sender_id": self.sender_id,
            "content": self.content,
            "message_type": self.message_type or "text",
            "reply_to": self.reply_to,
            "is_edited": self.is_edited or False,
            "is_read": self.is_read or False,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }