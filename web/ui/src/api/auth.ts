import { toApiError } from './errors'
import client, { setToken } from './client'

export interface LoginResponse {
  access_token: string
  refresh_token: string
}

export interface RegisterCaptchaResponse {
  id: string
  image: string
}

export async function login(email: string, password: string): Promise<void> {
  const res = await client.post<LoginResponse>('/login', { email, password })
  setToken(res.data.access_token)
}

export async function getCaptcha(): Promise<RegisterCaptchaResponse> {
  const res = await client.get<RegisterCaptchaResponse>('/register')
  return res.data
}

export async function register(
  email: string,
  password: string,
  password_repeat: string,
  c_id: string,
  c_code: string,
): Promise<void> {
  try {
    await client.post('/register', { email, password, password_repeat, c_id, c_code })
  } catch (e) {
    throw toApiError(e)
  }
}

export async function refresh(refresh_token?: string): Promise<LoginResponse> {
  const res = await client.post<LoginResponse>('/refresh', refresh_token ? { refresh_token } : {})
  return res.data
}

export async function logout(refresh_token?: string): Promise<void> {
  await client.post('/logout', refresh_token ? { refresh_token } : {})
}
