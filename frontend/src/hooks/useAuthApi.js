const API_BASE_URL = 'http://127.0.0.1:5000'

/**
 * Gọi API đăng ký.
 * @param {{ username: string, password: string, phone?: string, email?: string, bio?: string, avatar_url?: string }} payload
 * @returns {Promise<{ ok: boolean, data?: object, error?: string }>}
 */
export async function register(payload) {
  try {
    const response = await fetch(`${API_BASE_URL}/api/auth/register`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })
    const data = await response.json().catch(() => null)
    if (!response.ok) {
      return {
        ok: false,
        error: (data && (data.error || data.message)) || 'Đăng ký thất bại.',
      }
    }
    return { ok: true, data }
  } catch (err) {
    return { ok: false, error: 'Không thể kết nối tới server.' }
  }
}

/**
 * Gọi API đăng nhập (username, email hoặc phone + password).
 * @param {{ identifier?: string, username?: string, email?: string, phone?: string, password: string }} payload
 * @returns {Promise<{ ok: boolean, data?: object, error?: string }>}
 */
export async function login(payload) {
  try {
    const response = await fetch(`${API_BASE_URL}/api/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })
    const data = await response.json().catch(() => null)
    if (!response.ok) {
      return {
        ok: false,
        error: (data && (data.error || data.message)) || 'Đăng nhập thất bại.',
      }
    }
    return { ok: true, data }
  } catch (err) {
    return { ok: false, error: 'Không thể kết nối tới server.' }
  }
}

export { API_BASE_URL }
