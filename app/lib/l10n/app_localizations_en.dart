// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mayfly Pass';

  @override
  String get username => 'Username';

  @override
  String get login => 'Login';

  @override
  String get loginToAccount => 'Login to your account';

  @override
  String get register => 'Register';

  @override
  String get masterPassword => 'Master Password';

  @override
  String get confirmMasterPassword => 'Confirm Master Password';

  @override
  String get or => 'or';

  @override
  String get registerNewAccount => 'Register new account';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get usernameInvalid => 'Invalid username';

  @override
  String usernameTooShort(int min) {
    return 'Username must be at least $min characters long';
  }

  @override
  String usernameTooLong(int max) {
    return 'Username must be at less than $max characters long';
  }

  @override
  String passwordTooShort(int min) {
    return 'Password must be at least $min characters long';
  }

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully';

  @override
  String get accountAlreadyExists => 'An account with this username already exists';

  @override
  String get thereWasProblem => 'There was a problem while processing your request';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String loggedIn(String username) {
    return 'Welcome back $username';
  }

  @override
  String get invalidMasterPassword => 'Invalid master password';

  @override
  String get unlock => 'Unlock';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get newTotp => 'New TOTP';

  @override
  String totpSecretTooShort(int min) {
    return 'Secrete must be at least $min characters long';
  }

  @override
  String totpPeriodSeconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds seconds',
      one: '1 second',
      zero: '0 seconds',
    );
    return '$_temp0';
  }

  @override
  String get changePasswordSuccess => 'The master password has been updated successfully.\nPlease login to your account.';
}
