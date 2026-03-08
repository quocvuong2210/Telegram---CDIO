"""
Migration script để tạo bảng contacts.

Chạy lệnh: python -m flask db upgrade
Hoặc chạy script trực tiếp để tạo bảng.
"""

from app import create_app, db

app = create_app()

with app.app_context():
    # Tạo tất cả các bảng dựa trên models
    print("Creating database tables...")
    db.create_all()
    print("✓ Database tables created successfully!")
    
    # Kiểm tra nếu contacts table đã tồn tại
    inspector = db.inspect(db.engine)
    tables = inspector.get_table_names()
    
    print(f"\nExisting tables: {tables}")
    
    if 'contacts' in tables:
        print("✓ Contacts table exists!")
    else:
        print("✗ Contacts table not found!")
