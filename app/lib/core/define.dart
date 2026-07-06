// ignore: constant_identifier_names
const API_URL = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://127.0.0.1:8080',
);

// ignore: constant_identifier_names
const DEV_MODE = bool.fromEnvironment('DEV_MODE', defaultValue: false);
