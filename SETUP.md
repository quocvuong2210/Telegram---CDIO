# TELEGRAM-CDIO Setup Guide

## 1. Backend Setup

### Step 1: Cài đặt Dependencies
```bash
cd backend
pip install -r requirements.txt
```

### Step 2: Tạo Bảng Contacts (Database Migration)
```bash
python create_contacts_table.py
```

Hoặc nếu bạn muốn tạo từng bảng một:
```bash
python -c "from app import create_app, db; app = create_app(); db.create_all()"
```

### Step 3: Chạy Backend Server
```bash
python app.py
```

Backend sẽ chạy tại: `http://localhost:5000`

---

## 2. Frontend Setup

### Step 1: Cài đặt Dependencies
```bash
cd frontend
npm install
```

### Step 2: Kiểm tra API URL

Đảm bảo API_BASE_URL trong frontend đúng:
- File: `src/components/ChatInterface.jsx`
- Default: `http://localhost:5000`

### Step 3: Chạy Frontend Development Server
```bash
npm run dev
```

Frontend sẽ chạy tại: `http://localhost:5173` (hoặc port khác)

---

## 3. Testing APIs

### Test 1: Đăng ký (Register)
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "phone": "0912345678",
    "password": "password123",
    "avatar_url": "https://example.com/avatar.jpg",
    "bio": "Test user"
  }'
```

### Test 2: Đăng nhập (Login)
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "identifier": "testuser",
    "password": "password123"
  }'
```

Response sẽ trả về JSON chứa `user` và `access_token`.
**Trong frontend** token này được lưu vào `localStorage` với key `access_token` khi người dùng đăng nhập thành công.
Bạn cũng có thể sao chép token bằng DevTools để dùng cho curl hoặc Postman.

### Test 3: Lấy Thông Tin User
```bash
curl -X GET http://localhost:5000/api/auth/me \
  -H "Authorization: Bearer <access_token>"
```

### Test 4: Tìm Kiếm User
```bash
curl -X GET "http://localhost:5000/api/users/search?q=test&limit=10"
```

### Test 5: Cập Nhật Profile
```bash
curl -X PUT http://localhost:5000/api/users/profile \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "avatar_url": "https://example.com/new-avatar.jpg",
    "bio": "Updated bio",
    "phone": "0987654321"
  }'
```

### Test 6: Thêm Bạn
```bash
curl -X POST http://localhost:5000/api/contacts \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "contact_user_id": 2
  }'
```

### Test 7: Lấy Danh Sách Bạn
```bash
curl -X GET http://localhost:5000/api/contacts \
  -H "Authorization: Bearer <access_token>"
```

### Test 8: Xóa Bạn
```bash
curl -X DELETE http://localhost:5000/api/contacts/2 \
  -H "Authorization: Bearer <access_token>"
```

---

## 4. Frontend Features

### Hamburger Menu (ProfileMenu)
1. Nhấp vào icon hamburger ☰ ở header
2. Xem thông tin user
3. Chỉnh sửa profile
4. Sao chép ID user
5. Đăng xuất

### Search Bar (Add Friends)
1. Nhập tên hoặc số điện thoại của bạn bè
2. Xem danh sách kết quả tìm kiếm
3. Nhấp nút "Thêm" để thêm vào danh sách liên hệ
4. Nút sẽ chuyển thành "Đã thêm" khi đã thêm bạn

---

## 5. Database

### MySQL Connection
Default connection string:
```
mysql+mysqlconnector://root:123456@localhost/TELEGRAM_CDIO
```

Để thay đổi, set environment variable:
```bash
set MYSQL_CONN=mysql+mysqlconnector://user:password@host/database
```

### Tables
1. **users** - Lưu thông tin người dùng
2. **contacts** - Lưu danh sách liên hệ giữa các user
3. **messages** - Lưu tin nhắn (đã tồn tại)

---

## 6. Troubleshooting

### Lỗi: "No module named 'flask_jwt_extended'"
**Solution:** Cài đặt lại dependencies
```bash
pip install -r requirements.txt
```

### Lỗi: "ModuleNotFoundError" khi import Contact
**Solution:** Kiểm tra file `app/models/__init__.py` đã thêm `from .contact import Contact`

### Lỗi: "Contacts table does not exist"
**Solution:** Chạy migration script
```bash
python create_contacts_table.py
```

### API không tìm thấy
**Solution:** Kiểm tra:
1. Backend đang chạy (`python app.py`)
2. Cổng backend đúng (default: 5000)
3. Routes đã được đăng ký trong `app/__init__.py`

### Frontend không kết nối được backend
**Solution:** 
1. Kiểm tra CORS setting trong `app/__init__.py`
2. Kiểm tra API_BASE_URL trong component files
3. Kiểm tra backend server có chạy không

---

## 7. Environment Variables

Tạo file `.env` trong thư mục `backend`:
```
SECRET_KEY=your_secret_key_here
JWT_SECRET_KEY=your_jwt_secret_key_here
MYSQL_CONN=mysql+mysqlconnector://root:123456@localhost/TELEGRAM_CDIO
```

---

## 8. Project Structure

```
TELEGRAM-CDIO/
├── backend/
│   ├── app/
│   │   ├── models/
│   │   │   ├── user.py
│   │   │   ├── message.py
│   │   │   ├── contact.py (NEW)
│   │   │   └── __init__.py
│   │   ├── controllers/
│   │   │   ├── auth_controller.py
│   │   │   ├── user_controller.py (NEW)
│   │   │   └── contacts_controller.py (NEW)
│   │   ├── routes/
│   │   │   ├── auth_routes.py
│   │   │   ├── user_routes.py (NEW)
│   │   │   ├── contacts_routes.py (NEW)
│   │   │   └── main_routes.py
│   │   ├── config.py
│   │   └── __init__.py
│   ├── app.py
│   ├── requirements.txt
│   ├── create_contacts_table.py (NEW)
│   ├── API_DOCUMENTATION.md (NEW)
│   └── ...
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── ChatInterface.jsx (UPDATED)
│   │   │   ├── ProfileMenu.jsx (NEW)
│   │   │   ├── UpdateProfileModal.jsx (NEW)
│   │   │   ├── SearchBar.jsx (NEW)
│   │   │   └── ...
│   │   ├── styles/
│   │   │   ├── chat.css (UPDATED)
│   │   │   ├── profile-menu.css (NEW)
│   │   │   ├── update-profile-modal.css (NEW)
│   │   │   ├── search-bar.css (NEW)
│   │   │   └── ...
│   │   └── ...
│   └── ...
└── ...
```

---

## 9. Next Steps (Optional)

1. **Thêm Real-time Features**
   - Sử dụng WebSocket để real-time updates
   - Socket.IO integration

2. **Thêm File Upload**
   - Upload avatar thay vì chỉ URL
   - Sử dụng AWS S3 hoặc local storage

3. **Thêm Notification System**
   - Push notification khi có contact request
   - In-app notification

4. **Pagination**
   - Thêm pagination cho search results
   - Thêm infinite scroll cho contacts

5. **Message Features**
   - Xóa tin nhắn
   - Edit tin nhắn
   - Pinned messages

---

## 10. Support

Để tìm hiểu thêm chi tiết về API, xem [API_DOCUMENTATION.md](./API_DOCUMENTATION.md)
