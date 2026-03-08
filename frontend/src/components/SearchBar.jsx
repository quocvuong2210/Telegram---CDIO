import { useState, useEffect } from 'react';
import axios from 'axios';
import { Search, Check, X, Loader } from 'lucide-react';
import '../styles/search-bar.css';

export default function SearchBar({ currentUser, onContactAdded }) {
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [addingContactId, setAddingContactId] = useState(null);
  const [contacts, setContacts] = useState([]);
  const [isOpen, setIsOpen] = useState(false);

  // Lấy danh sách contacts hiện tại
  useEffect(() => {
    fetchContacts();
  }, []);

  const fetchContacts = async () => {
    try {
      const token = localStorage.getItem('access_token');
      const response = await axios.get(
        'http://localhost:5000/api/contacts',
        {
          headers: { 'Authorization': `Bearer ${token}` }
        }
      );
      setContacts(response.data.contacts.map(c => c.user.id));
    } catch (err) {
      console.error('Error fetching contacts:', err);
    }
  };

  const handleSearch = async (e) => {
    const query = e.target.value;
    setSearchQuery(query);
    setError('');

    if (!query.trim()) {
      setSearchResults([]);
      return;
    }

    setLoading(true);
    try {
      const response = await axios.get(
        `http://localhost:5000/api/users/search?q=${encodeURIComponent(query)}&limit=10`
      );
      
      // Lọc bỏ user hiện tại
      const filtered = response.data.users.filter(u => u.id !== currentUser?.id);
      setSearchResults(filtered);
    } catch (err) {
      setError('Lỗi tìm kiếm');
      setSearchResults([]);
    } finally {
      setLoading(false);
    }
  };

  const handleAddContact = async (contactUserId) => {
    setAddingContactId(contactUserId);
    try {
      const token = localStorage.getItem('access_token');
      await axios.post(
        'http://localhost:5000/api/contacts',
        { contact_user_id: contactUserId },
        {
          headers: { 'Authorization': `Bearer ${token}` }
        }
      );
      
      setContacts([...contacts, contactUserId]);
      onContactAdded?.();
    } catch (err) {
      const serverMsg =
        err.response?.data?.error ||
        err.response?.data?.msg ||
        err.response?.data?.message;
      setError(serverMsg || 'Lỗi thêm bạn');
    } finally {
      setAddingContactId(null);
    }
  };

  const isAlreadyContact = (userId) => contacts.includes(userId);

  return (
    <div className="search-bar-container">
      {/* Search Input */}
      <div className="search-input-wrapper">
        <Search size={20} className="search-icon" />
        <input
          type="text"
          placeholder="Tìm kiếm bạn bè..."
          value={searchQuery}
          onChange={handleSearch}
          onFocus={() => setIsOpen(true)}
          className="search-input"
        />
        {searchQuery && (
          <button 
            className="search-clear"
            onClick={() => {
              setSearchQuery('');
              setSearchResults([]);
              setIsOpen(false);
            }}
          >
            <X size={20} />
          </button>
        )}
      </div>

      {/* Search Results */}
      {isOpen && (searchResults.length > 0 || searchQuery) && (
        <div className="search-results">
          {loading && (
            <div className="search-loading">
              <Loader size={20} className="spinner" />
              <span>Đang tìm kiếm...</span>
            </div>
          )}

          {error && (
            <div className="search-error">{error}</div>
          )}

          {!loading && searchResults.length === 0 && searchQuery && (
            <div className="search-empty">
              Không tìm thấy kết quả
            </div>
          )}

          {!loading && searchResults.length > 0 && (
            <div className="results-list">
              {searchResults.map((user) => (
                <div key={user.id} className="result-item">
                  {user.avatar_url && (
                    <img 
                      src={user.avatar_url} 
                      alt={user.username}
                      className="result-avatar"
                    />
                  )}
                  
                  <div className="result-info">
                    <p className="result-username">{user.username}</p>
                    {user.bio && <p className="result-bio">{user.bio}</p>}
                    {user.phone && <p className="result-phone">{user.phone}</p>}
                  </div>

                  <button
                    className={`add-btn ${isAlreadyContact(user.id) ? 'added' : ''}`}
                    onClick={() => handleAddContact(user.id)}
                    disabled={isAlreadyContact(user.id) || addingContactId === user.id}
                  >
                    {isAlreadyContact(user.id) ? (
                      <>
                        <Check size={18} />
                        <span>Đã thêm</span>
                      </>
                    ) : addingContactId === user.id ? (
                      <Loader size={18} className="spinner" />
                    ) : (
                      <span>Thêm</span>
                    )}
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}
