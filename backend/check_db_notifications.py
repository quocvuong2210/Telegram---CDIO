from app import create_app
from app import db
from sqlalchemy import text

app = create_app()

with app.app_context():
    print("=== CHECKING NOTIFICATIONS IN DATABASE ===\n")

    try:
        # Query all notifications
        with db.engine.connect() as conn:
            result = conn.execute(text("SELECT * FROM notifications ORDER BY created_at DESC LIMIT 5"))
            notifications = result.fetchall()

        if notifications:
            print(f"✅ Found {len(notifications)} notifications:")
            for notif in notifications:
                print(f"  ID: {notif[0]}, User: {notif[1]}, Message: {notif[2]}, Is Read: {notif[3]}, Created: {notif[4]}")
        else:
            print("❌ No notifications found in database")

        # Also check messages table
        print("\n=== CHECKING MESSAGES IN DATABASE ===")
        with db.engine.connect() as conn:
            result = conn.execute(text("SELECT id, chat_id, sender_id, content FROM messages ORDER BY created_at DESC LIMIT 3"))
            messages = result.fetchall()

        if messages:
            print(f"✅ Found {len(messages)} recent messages:")
            for msg in messages:
                print(f"  ID: {msg[0]}, Chat: {msg[1]}, Sender: {msg[2]}, Content: {msg[3][:50]}...")
        else:
            print("❌ No messages found in database")

    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()