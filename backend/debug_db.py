#!/usr/bin/env python
"""Debug script to check database state"""
import sys
sys.path.insert(0, '.')

from app import create_app, db
from app.models import User, Message

app = create_app()
with app.app_context():
    print("=" * 50)
    print("DATABASE DEBUG INFO")
    print("=" * 50)
    
    # Check users
    users = User.query.all()
    print(f"\nTotal users in database: {len(users)}")
    for user in users:
        print(f"  - ID: {user.id}, Username: {user.username}, Email: {user.email}, Phone: {user.phone}")
    
    # Check messages
    messages = Message.query.all()
    print(f"\nTotal messages in database: {len(messages)}")
    for msg in messages:
        print(f"  - ID: {msg.id}, Chat: {msg.chat_id}, Sender: {msg.sender_id}, Content: {msg.content}")
    
    print("\n" + "=" * 50)
