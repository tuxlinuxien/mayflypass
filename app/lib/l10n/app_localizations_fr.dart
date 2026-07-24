// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Mayfly Pass';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get login => 'Connexion';

  @override
  String get loginToAccount => 'Connectez-vous à votre compte';

  @override
  String get register => 'S\'inscrire';

  @override
  String get masterPassword => 'Mot de passe principal';

  @override
  String get confirmMasterPassword => 'Confirmer le mot de passe principal';

  @override
  String get or => 'ou';

  @override
  String get registerNewAccount => 'Créer un nouveau compte';

  @override
  String get fieldRequired => 'Ce champ est obligatoire';

  @override
  String get usernameInvalid => 'Nom d\'utilisateur invalide';

  @override
  String usernameTooShort(int min) {
    return 'Le nom d\'utilisateur doit contenir au moins $min caractères';
  }

  @override
  String usernameTooLong(int max) {
    return 'Le nom d\'utilisateur ne peut pas dépasser $max caractères';
  }

  @override
  String passwordTooShort(int min) {
    return 'Le mot de passe doit contenir au moins $min caractères';
  }

  @override
  String get passwordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get accountCreatedSuccessfully => 'Compte créé avec succès';

  @override
  String get accountAlreadyExists => 'Un compte avec ce nom d\'utilisateur existe déjà';

  @override
  String get thereWasProblem => 'Un problème est survenu lors du traitement de votre demande';

  @override
  String get invalidCredentials => 'Identifiants invalides';

  @override
  String loggedIn(String username) {
    return 'Bonjour de retour $username';
  }

  @override
  String get invalidMasterPassword => 'Mot de passe principal invalide';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get settings => 'Paramètres';

  @override
  String get logout => 'Déconnexion';

  @override
  String get newTotp => 'Nouveau TOTP';

  @override
  String totpSecretTooShort(int min) {
    return 'La clé secrète doit contenir au moins $min caractères';
  }

  @override
  String totpPeriodSeconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds secondes',
      one: '1 seconde',
      zero: '0 seconde',
    );
    return '$_temp0';
  }

  @override
  String get changePasswordSuccess => 'Le mot de passe principal a été mis à jour avec succès.\nVeuillez vous connecter à votre compte.';

  @override
  String get addAccount => 'Ajouter un compte';

  @override
  String get updateAccount => 'Modifier le compte';

  @override
  String get scanQrCode => 'Scanner le code QR';

  @override
  String get scanQrDescription => 'Pointez votre caméra vers le code QR\naffiché par le service que vous ajoutez.';

  @override
  String get enterSetupKeyManually => 'Saisir la clé de configuration manuellement';

  @override
  String get save => 'Enregistrer';

  @override
  String get tags => 'Étiquettes';

  @override
  String get issuer => 'Émetteur';

  @override
  String get account => 'Compte';

  @override
  String get optional => '(facultatif)';

  @override
  String get secret => 'Clé secrète';

  @override
  String get algorithm => 'Algorithme';

  @override
  String get digits => 'Chiffres';

  @override
  String get period => 'Durée';

  @override
  String get accountSection => 'Compte';

  @override
  String get lastSynchronization => 'Dernière synchronisation';

  @override
  String get changePassword => 'Modifier le mot de passe';

  @override
  String get changePasswordDescription => 'Modifier le mot de passe de votre compte';

  @override
  String get securitySection => 'Sécurité';

  @override
  String get biometricUnlock => 'Déverrouillage biométrique';

  @override
  String get biometricUnlockDescription => 'Utiliser votre empreinte digitale pour déverrouiller l\'application';

  @override
  String get autoLock => 'Verrouillage automatique';

  @override
  String get autoLockDescription => 'Se verrouiller automatiquement après';

  @override
  String get backupImportSection => 'Sauvegarde / Importation';

  @override
  String get backup => 'Sauvegarde';

  @override
  String get backupDescription => 'Télécharger vos clés secrètes sur votre appareil';

  @override
  String get import => 'Importer';

  @override
  String get importDescription => 'Importer des clés secrètes dans votre compte';

  @override
  String get secretsExported => 'Vos clés secrètes ont été exportées';

  @override
  String secretsImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clés secrètes importées',
      one: '1 clé secrète importée',
      zero: 'Aucune clé secrète importée',
    );
    return '$_temp0';
  }

  @override
  String get biometricUnlockReason => 'Déverrouiller';
}
