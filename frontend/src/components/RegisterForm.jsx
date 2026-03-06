import { useState } from 'react'
import AuthLayout from './AuthLayout'
import { register as apiRegister } from '../hooks/useAuthApi'

export default function RegisterForm({ onSwitchToLogin }) {
  const [phone, setPhone] = useState('')
  const [firstName, setFirstName] = useState('')
  const [lastName, setLastName] = useState('')
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setSuccess('')

    if (!username || !password || !phone || !firstName) {
      setError('Vui lòng nhập đầy đủ Số điện thoại, Tên, Username và Mật khẩu.')
      return
    }

    setIsSubmitting(true)
    const normalizedPhone = phone.replace(/\D/g, '')
    const fullPhone = `+84 ${normalizedPhone}`
    const fullName = `${firstName} ${lastName}`.trim()

    const result = await apiRegister({
      username,
      password,
      phone: fullPhone,
      bio: fullName || undefined,
    })
    setIsSubmitting(false)

    if (result.ok) {
      setSuccess('Đăng ký thành công! Bạn có thể đăng nhập ngay bây giờ.')
      setPhone('')
      setFirstName('')
      setLastName('')
      setUsername('')
      setPassword('')
      // Automatically switch to login after successful registration
      setTimeout(() => onSwitchToLogin(), 2000)
    } else {
      setError(result.error)
    }
  }

  return (
    <AuthLayout
      title="Đăng ký Telegram"
      subtitle="Tạo tài khoản Telegram để bắt đầu trò chuyện an toàn và nhanh chóng."
    >
      <form className="auth-form" onSubmit={handleSubmit}>
        <div className="input-group">
          <label htmlFor="reg-phone">Số điện thoại</label>
          <div className="phone-input-container">
            <span className="prefix">+84</span>
            <input
              type="tel"
              id="reg-phone"
              placeholder="000 000 000"
              required
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
            />
          </div>
        </div>

        <div className="input-row">
          <div className="input-group">
            <label htmlFor="first-name">Tên</label>
            <input
              type="text"
              id="first-name"
              className="standard-input"
              placeholder="Tên của bạn"
              required
              value={firstName}
              onChange={(e) => setFirstName(e.target.value)}
            />
          </div>
          <div className="input-group">
            <label htmlFor="last-name">Họ (Tùy chọn)</label>
            <input
              type="text"
              id="last-name"
              className="standard-input"
              placeholder="Họ của bạn"
              value={lastName}
              onChange={(e) => setLastName(e.target.value)}
            />
          </div>
        </div>

        <div className="input-group">
          <label htmlFor="username">Username</label>
          <input
            type="text"
            id="username"
            className="standard-input"
            placeholder="Tên tài khoản (duy nhất)"
            required
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />
        </div>

        <div className="input-group">
          <label htmlFor="password">Mật khẩu</label>
          <input
            type="password"
            id="password"
            className="standard-input"
            placeholder="Mật khẩu"
            required
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
        </div>

        {error && <div className="message error-message">{error}</div>}
        {success && <div className="message success-message">{success}</div>}

        <button type="submit" className="btn-primary" disabled={isSubmitting}>
          {isSubmitting ? 'ĐANG ĐĂNG KÝ...' : 'ĐĂNG KÝ'}
        </button>

        <div className="bottom-link">
          <button
            type="button"
            className="text-link"
            onClick={onSwitchToLogin}
            style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 0 }}
          >
            Đã có tài khoản? Đăng nhập tại đây
          </button>
        </div>
      </form>
    </AuthLayout>
  )
}
