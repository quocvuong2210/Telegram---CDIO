import telegramLogo from '../assets/Telegram_logo.svg'

/**
 * Layout chung cho màn đăng ký / đăng nhập kiểu Telegram:
 * cột trái (logo + title + subtitle), cột phải (form).
 */
export default function AuthLayout({ title, subtitle, children }) {
  return (
    <div className="auth-root">
      <div className="auth-container">
        <div className="auth-left">
          <div className="auth-logo">
            <img src={telegramLogo} alt="Telegram Logo" />
          </div>
          <h1 className="auth-title">{title}</h1>
          <p className="auth-subtitle">{subtitle}</p>
        </div>
        {children}
      </div>
    </div>
  )
}
