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
  String get email => 'E-Mail';

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
  String get emailInvalid => 'Invalid email address';

  @override
  String passwordTooShort(int min) {
    return 'Password must be at least $min characters';
  }

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully';

  @override
  String get accountAlreadyExists => 'An account with this email already exists';

  @override
  String get thereWasProblem => 'There was a problem while processing your request';

  @override
  String get invalidCrentials => 'Invalid credentials';

  @override
  String loggedIn(String email) {
    return 'Welcome back $email';
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
}
