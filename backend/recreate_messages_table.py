#!/usr/bin/env python
"""Recreate messages table with correct schema"""
import sys
sys.path.insert(0, '.')

from app import create_app, db
from sqlalchemy import text

app = create_app()

with app.app_context():
    try:
        # Drop existing messages table if it exists
        print("Dropping messages table if it exists...")
        db.session.execute(text('DROP TABLE IF EXISTS messages'))
        db.session.commit()
        print("✓ Dropped messages table")
    except Exception as e:
        print(f"Error dropping table: {e}")
        db.session.rollback()
    
    try:
        # Create messages table with correct schema
        print("\nCreating messages table with correct schema...")
        from app.models import Message
        db.create_all()
        print("✓ Created messages table successfully")
        
        # Verify table structure
        result = db.session.execute(text("DESCRIBE messages")).fetchall()
        print("\nMessages table structure:")
        for row in result:
            print(f"  {row}")
            
    except Exception as e:
        print(f"Error creating table: {e}")
        import traceback
        traceback.print_exc()
        db.session.rollback()
