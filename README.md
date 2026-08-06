# MayflyPass

MayflyPass is an end-to-end-encrypted TOTP manager, with a lightweight Rust API and a Flutter app that keeps your codes in sync across devices.

## Screenshots

| Home | Add account (QR) | Add account (manual) | Settings |
| --- | --- | --- | --- |
| ![Home](resources/screenshots/home.jpg) | ![Add account via QR code](resources/screenshots/add_account_qrcode.jpg) | ![Add account manually](resources/screenshots/add_account_manual.jpg) | ![Settings](resources/screenshots/settings.jpg) |

## Encryption

MayflyPass uses envelope encryption end-to-end, so the server only ever sees ciphertext:

- The master password is hashed using Argon2id.
- A KEK (key-encryption-key) is derived from that hash using HKDF.
- Each entry gets its own random 32-bytes DEK (data-encryption-key), which is encrypted with the KEK using XChaCha20-Poly1305.
- The TOTP codes themselves are encrypted with their DEK using XChaCha20-Poly1305.

## APP

The app manages your TOTP entries entirely client-side. Secrets are added either by scanning a QR code or manual entry, stored locally on the device, and displayed on the home screen with a live rotating code and countdown timer.

Current tested target devices:

- [x] Android
- [x] Linux
- [ ] iOS
- [ ] Windows

> **Note on iOS:** I don't have a Mac nor a developer account, so I can't test whether the app runs properly, and I'm sure the Podfiles are missing important updates. if you have the opportunity to run it, feel free to create a merge request on github.

### API (Rust)

A small, resource-efficient backend that can run on very little hardware. It knows nothing about your TOTP secrets — it's a zero-knowledge blob store: storage only ever holds an encrypted key and an encrypted payload per item, both opaque to the server.

Registration is gated behind a lightweight proof-of-work challenge to deter bots, and authentication uses short-lived tokens with a refresh/login/logout flow, backed by strong password hashing. Account endpoints allow fetching account info and changing the password, which triggers the client-side key re-wrap described above.
