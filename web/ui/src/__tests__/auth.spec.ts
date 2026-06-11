import { describe, it, expect } from 'vitest'
import { register } from '../api/auth'
import { randomUUID } from 'crypto'

describe('register()', () => {
  it('throws on missing captcha', async () => {
    await expect(
      register(
        'user@example.com',
        '12345678',
        '12345678',
        '1bf88e79-1d81-4eee-8e81-b6cdcfc217de',
        '',
      ),
    ).rejects.toMatchObject({
      status: 400,
      errors: [{ code: 'VALUE_REQUIRED', field: 'c_code' }],
    })
  })

  it('throws on missing email', async () => {
    await expect(
      register('', '12345678', '12345678', '1bf88e79-1d81-4eee-8e81-b6cdcfc217de', '00000'),
    ).rejects.toMatchObject({
      status: 400,
      errors: [{ code: 'EMAIL_INVALID', field: 'email' }],
    })
  })

  it('throws on invalid email', async () => {
    await expect(
      register('testst', '12345678', '12345678', '1bf88e79-1d81-4eee-8e81-b6cdcfc217de', '00000'),
    ).rejects.toMatchObject({
      status: 400,
      errors: [{ code: 'EMAIL_INVALID', field: 'email' }],
    })
  })

  it('throws on password too short', async () => {
    await expect(
      register(
        'mail@test.com',
        '1234567',
        '1234567',
        '1bf88e79-1d81-4eee-8e81-b6cdcfc217de',
        '00000',
      ),
    ).rejects.toMatchObject({
      status: 400,
      errors: [{ code: 'VALUE_TOO_SHORT', field: 'password' }],
    })
  })

  it('throws dusplicated email', async () => {
    const testEmail = randomUUID() + '@test.com'
    await register(
      testEmail,
      '12345678',
      '12345678',
      '1bf88e79-1d81-4eee-8e81-b6cdcfc217de',
      '00000',
    )
    await expect(
      register(testEmail, '12345678', '12345678', '1bf88e79-1d81-4eee-8e81-b6cdcfc217de', '00000'),
    ).rejects.toMatchObject({
      status: 400,
      errors: [{ code: 'VALUE_DUPLICATED', field: 'email' }],
    })
  })

  it('is valid', async () => {
    await expect(
      register(
        randomUUID() + '@test.com',
        '12345678',
        '12345678',
        '1bf88e79-1d81-4eee-8e81-b6cdcfc217de',
        '00000',
      ),
    ).resolves.toBeUndefined()
  })
})
