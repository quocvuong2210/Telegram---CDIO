from app import create_app
from app import db
from sqlalchemy import text

app = create_app()

with app.app_context():
    print("=== CHECKING USERS IN DATABASE ===\n")

    try:
        # Check what users exist
        with db.engine.connect() as conn:
            result = conn.execute(text("SELECT id, username FROM users LIMIT 10"))
            users = result.fetchall()

        if users:
            print(f"✅ Found {len(users)} users:")
            for user in users:
                print(f"  ID: {user[0]}, Username: {user[1]}")
        else:
            print("❌ No users found in database")

        print("\n=== TESTING CHAT_ID CALCULATION ===")
        # Test the chat_id calculation logic
        test_chat_id = 2000003000001
        sender_id = 1

        min_user = test_chat_id // 1000000
        max_user = test_chat_id % 1000000
        recipient_id = max_user if sender_id == min_user else min_user

        print(f"Chat ID: {test_chat_id}")
        print(f"Sender ID: {sender_id}")
        print(f"Min user: {min_user}")
        print(f"Max user: {max_user}")
        print(f"Recipient ID: {recipient_id}")

        # Check if recipient exists
        with db.engine.connect() as conn:
            result = conn.execute(text(f"SELECT id, username FROM users WHERE id = {recipient_id}"))
            recipient = result.fetchone()

        if recipient:
            print(f"✅ Recipient exists: ID {recipient[0]}, Username: {recipient[1]}")
        else:
            print(f"❌ Recipient ID {recipient_id} does not exist in users table")

    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()