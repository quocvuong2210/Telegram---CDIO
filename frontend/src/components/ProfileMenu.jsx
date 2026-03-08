import { useState } from 'react';
import { Menu, X, LogOut, User, Copy } from 'lucide-react';
import UpdateProfileModal from './UpdateProfileModal';
import '../styles/profile-menu.css';

export default function ProfileMenu({ user, onLogout, onProfileUpdate }) {
  const [isOpen, setIsOpen] = useState(false);
  const [showUpdateModal, setShowUpdateModal] = useState(false);

  const handleLogout = () => {
    setIsOpen(false);
    onLogout();
  };

  const handleUpdateClick = () => {
    setShowUpdateModal(true);
    setIsOpen(false);
  };

  const handleProfileUpdated = (updatedUser) => {
    setShowUpdateModal(false);
    onProfileUpdate?.(updatedUser);
  };

  return (
    <>
      <div className="profile-menu">
        {/* Hamburger Button */}
        <button 
          className="hamburger-btn"
          onClick={() => setIsOpen(!isOpen)}
          aria-label="Menu"
        >
          {isOpen ? <X size={24} /> : <Menu size={24} />}
        </button>

        {/* Menu Dropdown */}
        {isOpen && (
          <div className="menu-dropdown">
            {/* User Info */}
            <div className="menu-user-info">
              {user?.avatar_url && (
                <img 
                  src={user.avatar_url} 
                  alt={user.username}
                  className="user-avatar"
                />
              )}
              <div className="user-details">
                <p className="user-username">{user?.username}</p>
                <p className="user-email">{user?.email || user?.phone}</p>
              </div>
            </div>

            <div className="menu-divider"></div>

            {/* Menu Items */}
            <button 
              className="menu-item"
              onClick={handleUpdateClick}
            >
              <User size={18} />
              <span>Chỉnh sửa profile</span>
            </button>

            <button 
              className="menu-item"
              onClick={() => {
                navigator.clipboard.writeText(user?.id);
                alert('Đã sao chép ID!');
              }}
            >
              <Copy size={18} />
              <span>Sao chép ID</span>
            </button>

            <div className="menu-divider"></div>

            <button 
              className="menu-item logout"
              onClick={handleLogout}
            >
              <LogOut size={18} />
              <span>Đăng xuất</span>
            </button>
          </div>
        )}
      </div>

      {/* Update Profile Modal */}
      {showUpdateModal && (
        <UpdateProfileModal 
          user={user}
          onClose={() => setShowUpdateModal(false)}
          onProfileUpdated={handleProfileUpdated}
        />
      )}
    </>
  );
}
