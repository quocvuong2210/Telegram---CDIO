# 🔔 Hệ Thống Thông Báo Tin Nhắn - Hướng Dẫn Sử Dụng

## 📝 Tổng Quan Tính Năng

Khi một người dùng nhận được tin nhắn mới, ứng dụng sẽ:
1. Tạo một **notification record** trong database
2. Gửi **socket event** cho người nhận
3. Hiển thị **🔔 icon + nội dung tin nhắn** dưới tên người gửi trong thanh contacts
4. Hiển thị **badge đỏ** với số lượng thông báo chưa đọc
5. Tự động **đánh dấu là đã đọc** khi người nhận mở cuộc trò chuyện

---

## 🏗️ Kiến Trúc Triển Khai

### Backend (Python/Flask)

#### 1. **Notification Model** 
```python
# backend/app/models/notification.py
class Notification(db.Model):
    id                  # ID thông báo
    user_id            # ID người nhận (FK → users)
    message_id         # ID tin nhắn (FK → messages)
    is_read            # Trạng thái đã đọc (True/False)
    created_at         # Thời gian tạo
```

#### 2. **Notification Routes**
Các endpoint API:
- `GET /api/notifications` - Lấy tất cả thông báo của người dùng
- `PUT /api/notifications/<notification_id>/read` - Đánh dấu 1 thông báo là đã đọc
- `PUT /api/notifications/read-all` - Đánh dấu tất cả thông báo là đã đọc
- `GET /api/notifications/unread/count` - Lấy số lượng thông báo chưa đọc
- `GET /api/notifications/by-sender/<sender_id>` - Lấy thông báo từ một người gửi

#### 3. **Socket Events (Real-time)**

**Server-side (`app/socket_events.py`):**
- `register_user` - Đăng ký người dùng để nhận thông báo
- `send_message` - Tự động tạo Notification khi có tin nhắn mới
- `mark_notification_as_read` - Đánh dấu thông báo là đã đọc

**Client-side (Frontend):**
- `new_notification` - Nhận thông báo mới từ server

### Frontend (React)

#### 1. **ChatInterface Component** - Các thay đổi chính:

**States thêm vào:**
```javascript
const [notifications, setNotifications] = useState({})
// Key: sender_id, Value: array of notification objects
```

**Listener cho socket events:**
```javascript
socketRef.current.on('new_notification', (notification) => {
  // Thêm thông báo vào state
  setNotifications(prev => ({
    ...prev,
    [notification.sender_id]: (prev[notification.sender_id] || []).concat(notification)
  }))
})
```

**Helper functions:**
- `getNotificationCount(chat)` - Đếm số thông báo từ một người gửi
- `getNotificationPreview(chat)` - Lấy nội dung tin nhắn của thông báo đầu tiên

**Xử lý khi mở chat:**
```javascript
const handleChatSelect = (chat) => {
  // 1. Tải tin nhắn cuộc trò chuyện
  // 2. Tự động đánh dấu tất cả thông báo từ người này là đã đọc
  // 3. Xóa thông báo khỏi danh sách
  setNotifications(prev => ({
    ...prev,
    [chat.id]: []
  }))
}
```

#### 2. **UI Display**

Trong thanh Contacts, mỗi liên hệ sẽ hiển thị:

```
┌─────────────────────────────────┐
│ [A]  John Doe                  │ ← Avatar + Tên
│      🔔 Hello, how are you?... │← Notification preview
│                            [2] │ ← Red badge với số lượng
└─────────────────────────────────┘

    (Màu cam nền khi có thông báo)
```

**Lưu ý:**
- Hiển thị thông báo (🔔) nếu có thông báo chưa đọc
- Hiển thị badge đỏ thay vì badge xanh
- Nền liên hệ chuyển thành màu cam

#### 3. **CSS Styles** (`frontend/src/styles/chat.css`)

Thêm các styles:
- `.notification-badge` - Badge đỏ với animation pulse
- `.chat-notification` - Text hiển thị thông báo
- `.has-notification` - Lớp CSS cho chat item có thông báo
- `@keyframes pulse` - Animation nhấp nháy cho badge

---

## 🔄 Luồng Hoạt Động

### Scenario: User A gửi tin nhắn cho User B

```
1. User A gửi tin nhắn
   └─> Socket event: 'send_message'
       
2. Backend xử lý:
   └─> Lưu Message vào database
   └─> Tính toán recipient_id từ chat_id
   └─> Tạo Notification record
   └─> Emit 'new_message' đến room chat_id
   └─> Emit 'new_notification' đến User B
   
3. User B nhận notification:
   └─> Socket event: 'new_notification'
   └─> Frontend cập nhật state notifications
   └─> Hiển thị 🔔 icon + preview dưới tên User A
   └─> Hiển thị badge đỏ (2)
   
4. User B mở cuộc trò chuyện với User A:
   └─> call handleChatSelect(User A)
   └─> Emit 'mark_notification_as_read' cho mỗi notification
   └─> Update database (notification.is_read = True)
   └─> Xóa notifications khỏi state
   └─> Hiển thị tin nhắn chat bình thường
```

---

## 🚀 Công Nghệ Sử Dụng

| Phần | Công Nghệ | Chi Tiết |
|------|-----------|---------|
| **Backend** | Flask + SQLAlchemy | SQLAlchemy ORM cho database |
| **Real-time** | Socket.IO | Gửi/nhận thông báo tức thời |
| **Frontend** | React | React hooks (useState, useRef) |
| **Database** | MySQL | Lưu notifications table |

---

## 📊 Ví Dụ Notification Object

```json
{
  "notification_id": 42,
  "message_id": 1001,
  "sender_id": 2000003,
  "sender_name": "John",
  "sender_avatar": "https://...",
  "content": "Hello! How are you?",
  "is_read": false,
  "created_at": "2026-03-08T19:37:40.123456"
}
```

---

## 🧪 Cách Kiểm Thử

### 1. Khởi động ứng dụng

**Backend:**
```bash
cd backend
python app.py
```
Server chạy trên: http://127.0.0.1:5000

**Frontend:**
```bash
cd frontend
npm run dev
```
Truy cập: http://localhost:5177

### 2. Kiểm thử tính năng

1. Mở 2 trình duyệt (hoặc 2 tab)
2. Đăng nhập 2 tài khoản khác nhau
3. Thêm nhau làm bạn (contacts)
4. User A gửi tin nhắn cho User B
5. Trên browser của User B:
   - ✅ Thấy 🔔 icon dưới tên User A
   - ✅ Thấy nội dung tin nhắn
   - ✅ Thấy badge đỏ với số 1
6. User B mở chat với User A:
   - ✅ Thông báo tự động biến mất
   - ✅ Thấy tin nhắn trong chat

---

## 📱 Giao Diện Thông Báo

### Trước khi mở chat:
```
Contacts           Messages
┌──────────────┐  ┌──────────────┐
│ [A] Alice    │  │ Select a chat│
│   Last msg.. │  │ to start     │
├──────────────┤  │ messaging    │
│ [B] Bob  [🔴2] │ │              │
│   🔔 Hi there│  │              │
├──────────────┤  │              │
│ [C] Carol    │  │              │
│   No message │  │              │
└──────────────┘  └──────────────┘
   ↑
 Thông báo từ Bob
```

### Sau khi mở chat:
```
Contacts           Messages
┌──────────────┐  ┌──────────────┐
│ [A] Alice    │  │ Bob           │
│   Last msg.. │  ├──────────────┤
├──────────────┤  │ Hi there     │
│ [B] Bob      │  │              │
│   Last msg.. │  │ Thanks!      │
├──────────────┤  ├──────────────┤
│ [C] Carol    │  │ Type message:│
│   No message │  │ [_________] │
└──────────────┘  └──────────────┘
   ↑
Thông báo biến mất
```

---

## 🔧 Troubleshooting

| Vấn Đề | Giải Pháp |
|--------|----------|
| Không thấy thông báo | Kiểm tra socket.io connection được thiết lập |
| Badge không hiển thị | Xác nhận `notifications` state được update |
| Thông báo không tự động biến mất | Kiểm tra `handleChatSelect` có gọi `mark_notification_as_read` |
| Lỗi database | Chạy `python fix_notifications_table.py` để tạo lại bảng với schema đúng |
| Lỗi "Unknown column 'message_id'" | Bảng notifications có schema sai, cần drop và recreate |
| Lỗi "Cannot add or update a child row" | Chat_id không hợp lệ hoặc user không tồn tại. Chat_id phải có format: min(user1,user2) * 1000000 + max(user1,user2) |

---

## 📂 File Thay Đổi

**Backend:**
- `app/models/notification.py` - Notification Model (NEW)
- `app/routes/notification_routes.py` - API Routes (NEW)
- `app/socket_events.py` - Socket Events (UPDATED)
- `app/__init__.py` - Register blueprint (UPDATED)
- `app/models/__init__.py` - Export Notification model (UPDATED)
- `app/routes/message_routes.py` - Added notification creation to REST API (UPDATED)
- `fix_notifications_table.py` - Script to fix database schema (NEW)
- `check_notifications_table.py` - Script to verify table schema (NEW)

**Frontend:**
- `components/ChatInterface.jsx` - Main component (UPDATED)
- `styles/chat.css` - Styling (UPDATED)

---

## ✨ Tính Năng Mở Rộng Trong Tương Lai

- [ ] Notification sound/vibration
- [ ] Desktop push notifications
- [ ] Notification history/archives
- [ ] Notification filters (mute certain contacts)
- [ ] Notification grouping by sender
- [ ] Emoji reactions in notifications

