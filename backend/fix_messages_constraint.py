#!/usr/bin/env python
"""Fix forward key constraint on messages table"""
import sys
sys.path.insert(0, '.')

from app import create_app, db
from sqlalchemy import text

app = create_app()

with app.app_context():
    try:
        print("Checking foreign key constraints on messages table...")
        
        # Get foreign keys on messages table
        result = db.session.execute(text("""
            SELECT CONSTRAINT_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME
            FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
            WHERE TABLE_NAME = 'messages'
            AND CONSTRAINT_NAME != 'PRIMARY'
        """)).fetchall()
        
        print("\nCurrent constraints:")
        for row in result:
            print(f"  {row}")
        
        # Drop incorrect constraint if it exists
        print("\nDropping incorrect chat_id foreign key if it exists...")
        try:
            db.session.execute(text("ALTER TABLE messages DROP FOREIGN KEY messages_ibfk_1"))
            db.session.commit()
            print("✓ Dropped constraint")
        except Exception as e:
            print(f"  Constraint doesn't exist or already dropped: {e}")
            db.session.rollback()
        
        # Verify final state
        print("\nFinal constraints on messages:")
        result = db.session.execute(text("""
            SELECT CONSTRAINT_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME
            FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
            WHERE TABLE_NAME = 'messages'
            AND CONSTRAINT_NAME != 'PRIMARY'
        """)).fetchall()
        
        for row in result:
            print(f"  {row}")
            
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
