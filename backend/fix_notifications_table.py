from app import create_app
from app import db
from sqlalchemy import text

app = create_app()

with app.app_context():
    try:
        # Drop the existing notifications table
        print("=== DROPPING EXISTING NOTIFICATIONS TABLE ===")
        with db.engine.connect() as conn:
            conn.execute(text("DROP TABLE IF EXISTS notifications"))
            conn.commit()
        print("✅ Successfully dropped notifications table")

        # Recreate all tables
        print("\n=== RECREATING ALL TABLES ===")
        db.create_all()
        print("✅ Successfully recreated all tables")

        # Verify the schema
        print("\n=== VERIFYING NOTIFICATIONS TABLE SCHEMA ===")
        inspector = db.inspect(db.engine)
        if 'notifications' in inspector.get_table_names():
            columns = inspector.get_columns('notifications')
            print("✅ Notifications table columns:")
            for col in columns:
                print(f"  - {col['name']}: {col['type']} (nullable: {col['nullable']})")
        else:
            print("❌ Notifications table does not exist!")

    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()