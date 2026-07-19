// ignore: constant_identifier_names
const API_URL = String.fromEnvironment(
  'API_URL',
  defaultValue: 'https://api.mayflypass.com',
);

// ignore: constant_identifier_names
const DEV_MODE = bool.fromEnvironment('DEV_MODE', defaultValue: false);
