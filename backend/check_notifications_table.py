from app import create_app
from app.models import Notification
from app import db

app = create_app()

with app.app_context():
    # Check if notifications table exists
    inspector = db.inspect(db.engine)
    tables = inspector.get_table_names()

    print("=== DATABASE TABLES ===")
    for table in tables:
        print(f"- {table}")

    print("\n=== NOTIFICATIONS TABLE SCHEMA ===")
    if 'notifications' in tables:
        columns = inspector.get_columns('notifications')
        for col in columns:
            print(f"- {col['name']}: {col['type']} (nullable: {col['nullable']})")
    else:
        print("❌ Table 'notifications' does not exist!")

    print("\n=== CREATING NOTIFICATIONS TABLE ===")
    try:
        db.create_all()
        print("✅ Successfully created all tables")
    except Exception as e:
        print(f"❌ Error creating tables: {e}")

    # Verify again
    print("\n=== VERIFICATION ===")
    tables_after = inspector.get_table_names()
    if 'notifications' in tables_after:
        columns_after = inspector.get_columns('notifications')
        print("✅ Notifications table exists with columns:")
        for col in columns_after:
            print(f"  - {col['name']}: {col['type']}")
    else:
        print("❌ Notifications table still does not exist!")