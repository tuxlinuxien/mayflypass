import axios from 'axios'

export type FieldError =
  | { code: 'VALUE_TOO_SHORT'; field: string; params: { min: number } }
  | { code: 'VALUE_TOO_LONG'; field: string; params: { max: number } }
  | { code: 'VALUE_RANGE'; field: string; params: { min: number; max: number } }
  | { code: 'VALUE_REQUIRED'; field: string }
  | { code: 'VALUE_MISMATCH'; field: string }
  | { code: 'VALUE_DUPLICATED'; field: string }
  | { code: 'EMAIL_INVALID'; field: string }
  | { code: 'CREDENTIALS_INVALID'; field: string }
  | { code: 'CAPTCHAT_INVALID'; field: string }

export type ApiError = { status: 400; errors: FieldError[] } | { status: 422 } | { status: number }

export function toApiError(e: unknown): ApiError {
  if (!axios.isAxiosError(e) || !e.response) {
    return { status: 0 }
  }
  const { status, data } = e.response
  if (status === 400) return { status, errors: data.errors }
  if (status === 422) return { status }
  return { status }
}
