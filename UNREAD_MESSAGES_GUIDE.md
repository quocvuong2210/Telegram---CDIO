# Hướng Dẫn: Tính Năng Đã Đọc/Chưa Đọc Tin Nhắn

## 📋 Tổng Quan

Tôi đã thêm các tính năng sau vào ứng dụng TELEGRAM-CDIO:

### 1. **Theo Dõi Trạng Thái Đã Đọc/Chưa Đọc**
   - Mỗi tin nhắn hiện được lưu trữ với trạng thái `is_read` (true/false)
   - Khi người dùng mở một cuộc trò chuyện, tất cả tin nhắn sẽ được tự động đánh dấu là đã đọc

### 2. **Hiển Thị Tin Nhắn Cuối Cùng Bên Cạnh Tên Liên Hệ**
   - Thanh bên trái (sidebar) hiển thị bản xem trước tin nhắn cuối cùng
   - Bao gồm ký tự đã đọc/chưa đọc:
     - `✓` = Tin nhắn đã gửi nhưng chưa đọc
     - `✓✓` = Tin nhắn đã đọc

### 3. **Biểu Tượng Số Tin Nhắn Chưa Đọc**
   - Một huy hiệu tròn xanh dương hiển thị số tin nhắn chưa đọc cho mỗi liên hệ
   - Tự động ẩn khi không có tin nhắn chưa đọc

### 4. **Biểu Chỉ Đã Đọc Trong Tin Nhắn**
   - Tin nhắn được gửi bởi người dùng hiện thị:
     - `✓` kế bên thời gian (chưa đọc)
     - `✓✓` kế bên thời gian (đã đọc)

---

## 🛠️ Thay Đổi Kỹ Thuật

### Backend (Python/Flask)

#### 1. **Model Dữ Liệu** (`backend/app/models/message.py`)
```python
is_read = db.Column(db.Boolean, nullable=False, default=False)
```
- Thêm trường `is_read` để theo dõi tin nhắn đã đọc

#### 2. **API Routes** (`backend/app/routes/message_routes.py`)
Thêm 3 endpoint mới:
- `PUT /api/messages/<message_id>/read` - Đánh dấu một tin nhắn là đã đọc
- `PUT /api/messages/<chat_id>/mark-all-read` - Đánh dấu tất cả tin nhắn trong cuộc trò chuyện
- `GET /api/messages/<chat_id>/latest` - Lấy tin nhắn gần đây nhất của một cuộc trò chuyện

#### 3. **Socket Events** (`backend/app/socket_events.py`)
Thêm 2 sự kiện Socket.IO mới:
- `mark_as_read` - Nhận sự kiện khi người dùng đọc một tin nhắn
- `mark_all_as_read` - Nhận sự kiện khi người dùng mở một cuộc trò chuyện

### Frontend (React)

#### 1. **ChatInterface Component** (`frontend/src/components/ChatInterface.jsx`)
Thêm các tính năng:
- `chatLastMessages` - Theo dõi tin nhắn cuối cùng cho mỗi cuộc trò chuyện
- `unreadCounts` - Theo dõi số tin nhắn chưa đọc cho mỗi cuộc trò chuyện
- `getLastMessagePreview()` - Hiển thị bản xem trước tin nhắn
- `getUnreadBadge()` - Hiển thị huy hiệu số tin nhắn chưa đọc
- Socket event listeners:
  - `message_read` - Cập nhật trạng thái đã đọc
  - `all_messages_read` - Đánh dấu tất cả tin nhắn là đã đọc

#### 2. **CSS** (`frontend/src/styles/chat.css`)
Thêm các style mới:
- `.unread-badge` - Huy hiệu tròn hiển thị số tin nhắn chưa đọc
- `.read-status` - Ký tự ✓/✓✓ hiển thị trạng thái đã đọc

---

## 📦 Cài Đặt

### 1. **Cập Nhật Database**

Chạy script migration để thêm cột `is_read`:

```bash
cd backend
python add_is_read_column.py
```

Hoặc, chạy trực tiếp SQL:
```sql
ALTER TABLE messages ADD COLUMN is_read BOOLEAN NOT NULL DEFAULT FALSE;
```

### 2. **Khởi Động Ứng Dụng**

**Backend:**
```bash
cd backend
python app.py
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev
```

---

## 🔄 Luồng Hoạt Động

### Gửi và Nhận Tin Nhắn
1. Người dùng A gửi tin nhắn → `is_read = false`
2. Người dùng B nhân được tin nhắn (socket: `new_message`)
3. Khi B mở cuộc trò chuyện → tất cả tin nhắn được đánh dấu là `is_read = true`
4. Biểu tượng ✓✓ hiển thị cho A (người gửi)

### Cập Nhật Giao Diện
- Thanh bên:
  - Hiển thị bản xem trước tin nhắn cuối + trạng thái đã đọc (✓ hoặc ✓✓)
  - Hiển thị huy hiệu số tin nhắn chưa đọc nếu có
- Trong cuộc trò chuyện:
  - Tin nhắn được gửi hiển thị ✓ hoặc ✓✓ kế bên thời gian

---

## 📝 API Documentation

### Mark Single Message as Read
```
PUT /api/messages/<message_id>/read
Response: { "id": 1, "is_read": true, ... }
```

### Mark All Messages in Chat as Read
```
PUT /api/messages/<chat_id>/mark-all-read
Response: { "status": "success", "count": 5 }
```

### Get Latest Message
```
GET /api/messages/<chat_id>/latest
Response: { "id": 1, "content": "...", "is_read": true, ... }
```

---

## 🎯 Các Tính Năng Tương Lai (Optional)

- [ ] Lưu trạng thái `is_read` trên mỗi người dùng (cho nhóm)
- [ ] Hiển thị thời gian "đã đọc" thay vì chỉ là ✓✓
- [ ] Thông báo khi người dùng đang gõ tin nhắn
- [ ] Tính năng xóa tin nhắn
- [ ] Tính năng chỉnh sửa tin nhắn

---

## 🐛 Khắc Phục Sự Cố

### Tin nhắn không được đánh dấu là đã đọc
- Kiểm tra xem database migration đã chạy chưa
- Kiểm tra browser console để xem socket errors

### Không thấy số tin nhăn chưa đọc
- Kiểm tra xem socket connection đã được kết nối chưa
- Xóa localStorage và tải lại trang

### Last message preview không hiển thị
- Đảm bảo endpoint `/api/messages/<chat_id>/latest` hoạt động
- Kiểm tra network tab trong developer tools
