import { useState } from 'react'
import { useAuth } from '../contexts/AuthContext'
import AuthLayout from './AuthLayout'
import { login as apiLogin } from '../hooks/useAuthApi'

export default function LoginForm({ onSwitchToRegister }) {
  const { login } = useAuth()
  const [identifier, setIdentifier] = useState('')
  const [password, setPassword] = useState('')
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setSuccess('')

    if (!identifier || !password) {
      setError('Vui lòng nhập Username / Email / Số điện thoại và Mật khẩu.')
      return
    }

    setIsSubmitting(true)
    const result = await apiLogin({
      identifier: identifier.trim(),
      password,
    })
    setIsSubmitting(false)

    if (result.ok) {
      setSuccess('Đăng nhập thành công!')
      setIdentifier('')
      setPassword('')
      if (result.data && result.data.user) {
        console.log('DEBUG: User logged in successfully', result.data.user)
        login(result.data.user)
      }
    } else {
      setError(result.error)
    }
  }

  return (
    <AuthLayout
      title="Đăng nhập Telegram"
      subtitle="Nhập Username, Email hoặc Số điện thoại và mật khẩu để đăng nhập."
    >
      <form className="auth-form" onSubmit={handleSubmit}>
        <div className="input-group">
          <label htmlFor="login-identifier">Username / Email / Số điện thoại</label>
          <input
            type="text"
            id="login-identifier"
            className="standard-input"
            placeholder="Username, email hoặc +84..."
            required
            value={identifier}
            onChange={(e) => setIdentifier(e.target.value)}
          />
        </div>

        <div className="input-group">
          <label htmlFor="login-password">Mật khẩu</label>
          <input
            type="password"
            id="login-password"
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
          {isSubmitting ? 'ĐANG ĐĂNG NHẬP...' : 'ĐĂNG NHẬP'}
        </button>

        <div className="bottom-link">
          <button
            type="button"
            className="text-link"
            onClick={onSwitchToRegister}
            style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 0 }}
          >
            Chưa có tài khoản? Đăng ký tại đây
          </button>
        </div>
      </form>
    </AuthLayout>
  )
}
