import { createContext, useContext, useState, useEffect } from 'react'

const AuthContext = createContext()

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null)
  const [token, setToken] = useState(null)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    // Check if user is logged in (e.g., from localStorage)
    const storedUser = localStorage.getItem('user')
    const storedToken = localStorage.getItem('access_token')
    if (storedUser) {
      setUser(JSON.parse(storedUser))
    }
    if (storedToken) {
      setToken(storedToken)
    }
    setIsLoading(false)
  }, [])

  const login = (userData, accessToken) => {
    setUser(userData)
    if (accessToken) {
      setToken(accessToken)
      localStorage.setItem('access_token', accessToken)
    }
    localStorage.setItem('user', JSON.stringify(userData))
  }

  const logout = () => {
    setUser(null)
    setToken(null)
    localStorage.removeItem('user')
    localStorage.removeItem('access_token')
  }

  return (
    <AuthContext.Provider value={{ user, token, login, logout, isLoading }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  return useContext(AuthContext)
}