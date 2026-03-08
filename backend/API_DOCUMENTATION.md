# API Documentation - TELEGRAM-CDIO

## Overview
Các API được xây dựng hỗ trợ:
- **GET /api/users/search** - Tìm kiếm người dùng
- **PUT /api/users/profile** - Cập nhật profile
- **POST /api/contacts** - Thêm bạn vào danh sách liên hệ
- **GET /api/contacts** - Lấy danh sách bạn bè
- **DELETE /api/contacts/<contact_user_id>** - Xóa bạn khỏi danh sách

---

## 1. Authentication APIs

### GET /api/auth/me
Lấy thông tin cá nhân của người dùng hiện tại từ token.

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "user": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "phone": "0912345678",
    "avatar_url": "https://example.com/avatar.jpg",
    "bio": "Hello there!",
    "is_online": true,
    "last_seen": "2026-03-08T10:30:00",
    "created_at": "2026-03-08T09:00:00",
    "updated_at": "2026-03-08T10:30:00"
  }
}
```

---

## 2. User APIs

### GET /api/users/search
Tìm kiếm người dùng theo username hoặc phone.

**Query Parameters:**
- `q` (required): Chuỗi tìm kiếm
- `limit` (optional): Số kết quả tối đa (mặc định: 10)

**Example:**
```
GET /api/users/search?q=john&limit=10
```

**Response (200):**
```json
{
  "users": [
    {
      "id": 1,
      "username": "john_doe",
      "email": "john@example.com",
      "phone": "0912345678",
      "avatar_url": "https://example.com/avatar.jpg",
      "bio": "Hello there!",
      "is_online": true,
      "last_seen": "2026-03-08T10:30:00",
      "created_at": "2026-03-08T09:00:00",
      "updated_at": "2026-03-08T10:30:00"
    }
  ],
  "total": 1
}
```

---

### PUT /api/users/profile
Cập nhật thông tin profile của người dùng hiện tại.

**Headers:**
```
Authorization: Bearer <access_token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "avatar_url": "https://example.com/new-avatar.jpg",
  "bio": "New bio",
  "phone": "0987654321"
}
```
Tất cả các trường đều tùy chọn (optional).

**Response (200):**
```json
{
  "user": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "phone": "0987654321",
    "avatar_url": "https://example.com/new-avatar.jpg",
    "bio": "New bio",
    "is_online": true,
    "last_seen": "2026-03-08T10:30:00",
    "created_at": "2026-03-08T09:00:00",
    "updated_at": "2026-03-08T10:35:00"
  }
}
```

---

## 3. Contacts APIs

### GET /api/contacts
Lấy danh sách liên hệ của người dùng hiện tại.

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "contacts": [
    {
      "contact_id": 1,
      "user": {
        "id": 2,
        "username": "jane_smith",
        "email": "jane@example.com",
        "phone": "0912345679",
        "avatar_url": "https://example.com/jane-avatar.jpg",
        "bio": "Jane's bio",
        "is_online": false,
        "last_seen": "2026-03-08T09:00:00",
        "created_at": "2026-03-08T08:00:00",
        "updated_at": "2026-03-08T09:00:00"
      },
      "added_at": "2026-03-08T09:30:00"
    }
  ],
  "total": 1
}
```

---

### POST /api/contacts
Thêm một người dùng vào danh sách liên hệ.

**Headers:**
```
Authorization: Bearer <access_token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "contact_user_id": 2
}
```

**Response (201):**
```json
{
  "contact": {
    "id": 1,
    "user_id": 1,
    "contact_user_id": 2,
    "created_at": "2026-03-08T09:30:00"
  },
  "contact_user": {
    "id": 2,
    "username": "jane_smith",
    "email": "jane@example.com",
    "phone": "0912345679",
    "avatar_url": "https://example.com/jane-avatar.jpg",
    "bio": "Jane's bio",
    "is_online": false,
    "last_seen": "2026-03-08T09:00:00",
    "created_at": "2026-03-08T08:00:00",
    "updated_at": "2026-03-08T09:00:00"
  }
}
```

**Error Responses:**
- **400**: Contact already exists hoặc contact user not found
- **401**: User not found

---

### DELETE /api/contacts/<contact_user_id>
Xóa một người dùng khỏi danh sách liên hệ.

**Headers:**
```
Authorization: Bearer <access_token>
```

**URL Parameters:**
- `contact_user_id`: ID của contact cần xóa

**Example:**
```
DELETE /api/contacts/2
```

**Response (200):**
```json
{
  "message": "Contact removed successfully"
}
```

**Error Responses:**
- **400**: Contact not found
- **401**: User not found

---

## Database Models

### Users Table
```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(255),
    bio TEXT,
    is_online BOOLEAN DEFAULT FALSE,
    last_seen DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Contacts Table
```sql
CREATE TABLE contacts (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL FOREIGN KEY REFERENCES users(id) ON DELETE CASCADE,
    contact_user_id BIGINT NOT NULL FOREIGN KEY REFERENCES users(id) ON DELETE CASCADE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_contact (user_id, contact_user_id)
);
```

---

## Frontend Components

### ProfileMenu
Located: `frontend/src/components/ProfileMenu.jsx`

Hamburger menu để:
- Xem thông tin user
- Chỉnh sửa profile
- Sao chép ID
- Đăng xuất

### UpdateProfileModal
Located: `frontend/src/components/UpdateProfileModal.jsx`

Modal để chỉnh sửa:
- Avatar URL
- Bio
- Phone

### SearchBar
Located: `frontend/src/components/SearchBar.jsx`

Thanh tìm kiếm để:
- Tìm kiếm người dùng theo username/phone
- Thêm bạn vào danh sách liên hệ
- Hiển thị danh sách kết quả tìm kiếm

---

## Error Handling

Tất cả các API trả về error response với format:
```json
{
  "error": "Error description"
}
```

Các HTTP status codes:
- **200**: OK
- **201**: Created
- **400**: Bad Request
- **401**: Unauthorized
- **500**: Server Error

---

## Testing with cURL

### Search Users
```bash
curl -X GET "http://localhost:5000/api/users/search?q=john" \
  -H "Content-Type: application/json"
```

### Update Profile
```bash
curl -X PUT "http://localhost:5000/api/users/profile" \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "avatar_url": "https://example.com/avatar.jpg",
    "bio": "New bio",
    "phone": "0987654321"
  }'
```

### Add Contact
```bash
curl -X POST "http://localhost:5000/api/contacts" \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "contact_user_id": 2
  }'
```

### Get Contacts
```bash
curl -X GET "http://localhost:5000/api/contacts" \
  -H "Authorization: Bearer <access_token>"
```

### Delete Contact
```bash
curl -X DELETE "http://localhost:5000/api/contacts/2" \
  -H "Authorization: Bearer <access_token>"
```
