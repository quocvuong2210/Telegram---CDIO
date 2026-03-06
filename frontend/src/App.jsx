import { useState } from 'react'
import { AuthProvider, useAuth } from './contexts/AuthContext'
import LoginForm from './components/LoginForm'
import RegisterForm from './components/RegisterForm'
import ChatInterface from './components/ChatInterface'
import './styles/auth.css'
import './styles/chat.css'

function AppContent() {
  const { user, isLoading } = useAuth()
  const [isLogin, setIsLogin] = useState(true)

  if (isLoading) {
    return <div>Loading...</div>
  }

  if (user) {
    return <ChatInterface />
  }

  return isLogin ? (
    <LoginForm onSwitchToRegister={() => setIsLogin(false)} />
  ) : (
    <RegisterForm onSwitchToLogin={() => setIsLogin(true)} />
  )
}

export default function App() {
  return (
    <AuthProvider>
      <AppContent />
    </AuthProvider>
  )
}
