import { useState, useRef } from 'react';
import axios from 'axios';
import { X, Upload } from 'lucide-react';
import '../styles/update-profile-modal.css';

export default function UpdateProfileModal({ user, onClose, onProfileUpdated }) {
  const fileInputRef = useRef(null);
  const [formData, setFormData] = useState({
    avatar_url: user?.avatar_url || '',
    bio: user?.bio || '',
    phone: user?.phone || ''
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleFileSelect = (e) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // Kiểm tra loại file
    if (!file.type.startsWith('image/')) {
      setError('Vui lòng chọn một file hình ảnh');
      return;
    }

    // Kiểm tra kích thước (max 5MB)
    if (file.size > 5 * 1024 * 1024) {
      setError('Kích thước hình ảnh không được vượt quá 5MB');
      return;
    }

    // Chuyển đổi file thành Data URL
    const reader = new FileReader();
    reader.onload = (e) => {
      setFormData(prev => ({
        ...prev,
        avatar_url: e.target?.result || ''
      }));
      setError('');
    };
    reader.onerror = () => {
      setError('Có lỗi khi đọc file');
    };
    reader.readAsDataURL(file);
  };

  const handleUploadClick = () => {
    fileInputRef.current?.click();
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const token = localStorage.getItem('access_token');
      const response = await axios.put(
        'http://localhost:5000/api/users/profile',
        formData,
        {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        }
      );

      onProfileUpdated(response.data.user);
    } catch (err) {
      setError(err.response?.data?.error || 'Có lỗi xảy ra');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        {/* Header */}
        <div className="modal-header">
          <h2>Chỉnh sửa profile</h2>
          <button className="close-btn" onClick={onClose}>
            <X size={24} />
          </button>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="profile-form">
          {error && <div className="error-message">{error}</div>}

          {/* Avatar Section */}
          <div className="form-group">
            <label>Ảnh đại diện</label>
            <div className="avatar-upload-section">
              {/* Upload Button */}
              <button 
                type="button"
                className="avatar-upload-btn"
                onClick={handleUploadClick}
              >
                <Upload size={20} />
                <span>Chọn ảnh</span>
              </button>

              {/* Hidden File Input */}
              <input
                ref={fileInputRef}
                type="file"
                accept="image/*"
                onChange={handleFileSelect}
                className="hidden-file-input"
              />

              {/* Avatar Preview and URL Input */}
              <div className="avatar-input-area">
                {formData.avatar_url && (
                  <div className="avatar-preview">
                    <img src={formData.avatar_url} alt="Preview" />
                  </div>
                )}
                <input
                  type="url"
                  id="avatar_url"
                  name="avatar_url"
                  value={formData.avatar_url}
                  onChange={handleInputChange}
                  placeholder="Hoặc dán URL hình ảnh..."
                  className="form-input"
                />
              </div>
            </div>
          </div>

          {/* Bio */}
          <div className="form-group">
            <label htmlFor="bio">Tiểu sử</label>
            <textarea
              id="bio"
              name="bio"
              value={formData.bio}
              onChange={handleInputChange}
              placeholder="Nhập tiểu sử của bạn..."
              className="form-textarea"
              rows="4"
            ></textarea>
          </div>

          {/* Phone */}
          <div className="form-group">
            <label htmlFor="phone">Số điện thoại</label>
            <input
              type="tel"
              id="phone"
              name="phone"
              value={formData.phone}
              onChange={handleInputChange}
              placeholder="0912345678"
              className="form-input"
            />
          </div>

          {/* Buttons */}
          <div className="form-buttons">
            <button 
              type="button" 
              className="btn btn-cancel"
              onClick={onClose}
              disabled={loading}
            >
              Hủy
            </button>
            <button 
              type="submit" 
              className="btn btn-primary"
              disabled={loading}
            >
              {loading ? 'Đang lưu...' : 'Lưu'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
