from datetime import datetime
from .. import db


class Contact(db.Model):
    """
    Danh sách liên hệ của người dùng.
    
    CREATE TABLE contacts (
        id BIGINT PRIMARY KEY AUTO_INCREMENT,
        user_id BIGINT NOT NULL FOREIGN KEY users(id),
        contact_user_id BIGINT NOT NULL FOREIGN KEY users(id),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY unique_contact (user_id, contact_user_id)
    );
    """
    __tablename__ = "contacts"
    
    id = db.Column(db.BigInteger, primary_key=True, autoincrement=True)
    user_id = db.Column(db.BigInteger, db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False, index=True)
    contact_user_id = db.Column(db.BigInteger, db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False, index=True)
    created_at = db.Column(db.DateTime, nullable=False, server_default=db.func.current_timestamp())
    
    # Unique constraint để tránh thêm cùng một contact 2 lần
    __table_args__ = (
        db.UniqueConstraint('user_id', 'contact_user_id', name='unique_contact'),
    )
    
    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "user_id": self.user_id,
            "contact_user_id": self.contact_user_id,
            "created_at": self.created_at.isoformat() if self.created_at else None,
        }
