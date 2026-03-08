# 🚀 Hướng Dẫn Khởi Động Nhanh - Tính Năng Tin Nhắn Đã Đọc/Chưa Đọc

## ✅ Những Gì Đã Được Thêm

### 1. **Backend**
- ✅ Thêm cột `is_read` vào model `Message`
- ✅ API endpoints để đánh dấu tin nhắn là đã đọc
- ✅ Socket events để xử lý read receipts (biên lai đọc)
- ✅ Script migration để cập nhật database

### 2. **Frontend**
- ✅ Hiển thị tin nhắn cuối cùng bên cạnh tên liên hệ
- ✅ Biểu tượng ✓ / ✓✓ để chỉ trạng thái đã đọc
- ✅ Huy hiệu số tin nhắn chưa đọc (blue badge)
- ✅ Auto-mark messages as read khi mở chat

---

## 📦 Cài Đặt (Bước Cần Làm Ngay)

### Bước 1: Cập Nhật Database

```bash
cd backend
python add_is_read_column.py
```

**Output mong đợi:**
```
✓ is_read column already exists
hoặc
✓ is_read column added successfully
```

### Bước 2: Khởi Động Backend
```bash
cd backend
python app.py
```

### Bước 3: Khởi Động Frontend
```bash
cd frontend
npm run dev
```

---

## 👀 Tính Năng Được Hiển Thị

### 📝 Thanh Bên (Sidebar)
```
[D]  Donald          
     Last messa... ✓✓    [2]
```
- **D** = Avatar (chữ cái đầu tên)
- **Last messa...** = Bản xem trước tin nhắn cuối
- **✓✓** = Tin nhắn đã đọc (✓ = chưa đọc)
- **[2]** = Huy hiệu: 2 tin nhắn chưa đọc (chỉ hiển thị nếu > 0)

### 💬 Nội Dung Chat
```
[User]
Hello friend!
2:30 PM ✓

Response from friend
2:35 PM

[User] 
How are you?
2:40 PM ✓✓ (người dùng kia đã đọc)
```

---

## 🔧 File Đã Thay Đổi

| File | Thay Đổi |
|------|---------|
| `backend/app/models/message.py` | Thêm `is_read` field |
| `backend/app/routes/message_routes.py` | Thêm 3 endpoints mới |
| `backend/app/socket_events.py` | Thêm read receipt handlers |
| `backend/add_is_read_column.py` | 🆕 Script migration |
| `frontend/src/components/ChatInterface.jsx` | Logic unread/read + last message |
| `frontend/src/styles/chat.css` | CSS cho badge và icons |

---

## 🧪 Kiểm Tra Hoạt Động

1. **Đăng nhập với 2 tài khoản khác nhau** (hoặc 2 browser)
2. **Tài khoản A gửi tin nhắn** cho tài khoản B
3. **Kiểm tra tài khoản B:**
   - ✓ Thanh bên hiển thị tin nhắn với `✓`
   - ✓ Huy hiệu xanh dương hiển thị "1"
4. **Tài khoản B mở chat:**
   - ✓ Huy hiệu biến mất
   - ✓ Tài khoản A thấy `✓✓`

---

## ⚠️ Khắc Phục Sự Cố

### Vấn đề: Cột `is_read` không được thêm
**Giải pháp:**
```bash
# Chạy trực tiếp SQL
mysql -u root -p [database_name]
ALTER TABLE messages ADD COLUMN is_read BOOLEAN NOT NULL DEFAULT FALSE;
```

### Vấn đề: Chrome DevTools console hiển thị socket errors
**Giải pháp:**
- Kiểm tra backend đang chạy: `http://127.0.0.1:5000`
- Kiểm tra CORS settings trong `backend/app/__init__.py`

### Vấn đề: Huy hiệu chưa đọc không cập nhật
**Giải pháp:**
- Xóa localStorage: 
  ```javascript
  localStorage.clear()
  location.reload()
  ```
- Kiểm tra socket connection trong DevTools → Network → WS

---

## 📚 Tài Liệu Chi Tiết

Xem file `UNREAD_MESSAGES_GUIDE.md` để:
- API Documentation
- Luồng hoạt động chi tiết
- Danh sách tính năng tương lai

---

## 💡 Lưu Ý Quan Trọng

1. **Database migration là bắt buộc** trước khi chạy ứng dụng lần đầu
2. **Tin nhắn cũ** sẽ có `is_read = false` (mặc định)
3. **Socket connection** cần được kết nối để real-time updates hoạt động
4. **Tải lại trang** để reset state nếu có vấn đề

---

## 🎯 Các Bước Tiếp Theo (Optional)

- [ ] Thêm thời gian "Seen at" thay vì chỉ ✓✓
- [ ] Thêm indicator "User is typing"
- [ ] Lưu unread count trong localStorage
- [ ] Thêm sound notification cho tin nhắn mới
- [ ] Thêm tính năng delete/edit message

---

**Chúc bạn sử dụng vui vẻ! 🎉**
