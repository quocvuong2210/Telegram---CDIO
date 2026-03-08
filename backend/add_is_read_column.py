"""
Migration script to add is_read column to messages table
"""
from app import create_app, db
from sqlalchemy import text

app = create_app()

with app.app_context():
    try:
        # Check if column already exists
        result = db.session.execute(
            text("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='messages' AND COLUMN_NAME='is_read'")
        )
        column_exists = result.fetchone() is not None
        
        if column_exists:
            print("✓ is_read column already exists")
        else:
            # Add the column
            db.session.execute(
                text("ALTER TABLE messages ADD COLUMN is_read BOOLEAN NOT NULL DEFAULT FALSE")
            )
            db.session.commit()
            print("✓ is_read column added successfully")
            
    except Exception as e:
        db.session.rollback()
        print(f"✗ Error: {e}")
