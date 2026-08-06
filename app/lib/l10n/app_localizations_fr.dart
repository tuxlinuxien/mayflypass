// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'S\'inscrire';

  @override
  String get masterPassword => 'Mot de passe principal';

  @override
  String get confirmMasterPassword => 'Confirmer le mot de passe principal';

  @override
  String get or => 'ou';

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
  String get accountAlreadyExists =>
      'Un compte avec ce nom d\'utilisateur existe déjà';

  @override
  String get thereWasProblem =>
      'Un problème est survenu lors du traitement de votre demande';

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
  String totpSecretTooShort(int min) {
    return 'La clé secrète doit contenir au moins $min caractères';
  }

  @override
  String totpSecretTooLong(int max) {
    return 'La clé secrète ne peut pas dépasser $max caractères';
  }

  @override
  String get totpSecretFormatError {
    return 'Le secret ne supporte que les caractères A-Z, a-z';
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
  String get changePasswordSuccess =>
      'Le mot de passe principal a été mis à jour avec succès.\nVeuillez vous connecter à votre compte.';

  @override
  String get addAccount => 'Ajouter un compte';

  @override
  String get updateAccount => 'Modifier le compte';

  @override
  String get scanQrCode => 'Scanner le code QR';

  @override
  String get scanQrDescription =>
      'Pointez votre caméra vers le code QR\naffiché par le service que vous ajoutez.';

  @override
  String get enterSetupKeyManually =>
      'Saisir la clé de configuration manuellement';

  @override
  String get save => 'Enregistrer';

  @override
  String get tags => 'Étiquettes';

  @override
  String get issuer => 'Émetteur';

  @override
  String totpIssuerTooLong(int max) {
    return 'L\'émetteur ne peut pas dépasser $max caractères';
  }

  @override
  String get account => 'Compte';

  @override
  String totpAccountTooLong(int max) {
    return 'Le compte ne peut pas dépasser $max caractères';
  }

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
  String get changePasswordDescription =>
      'Modifier le mot de passe de votre compte';

  @override
  String get securitySection => 'Sécurité';

  @override
  String get biometricUnlock => 'Déverrouillage biométrique';

  @override
  String get biometricUnlockDescription =>
      'Utiliser votre empreinte digitale pour déverrouiller l\'application';

  @override
  String get autoLock => 'Verrouillage automatique';

  @override
  String get autoLockDescription => 'Se verrouiller automatiquement après';

  @override
  String get backupImportSection => 'Sauvegarde / Importation';

  @override
  String get backup => 'Sauvegarde';

  @override
  String get backupDescription =>
      'Télécharger vos clés secrètes sur votre appareil';

  @override
  String get import => 'Importer';

  @override
  String get importDescription =>
      'Importer des clés secrètes dans votre compte';

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

  @override
  String get loginWelcomeTitle => 'Bon retour';

  @override
  String get loginSubtitle =>
      'Connectez-vous à Mayfly Pass pour synchroniser vos codes.';

  @override
  String get loginSubmit => 'Connexion';

  @override
  String get loginNewHerePrefix => 'Nouveau ici ? ';

  @override
  String get loginCreateAccountLink => 'Créer un compte';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get registerSubtitle =>
      'Vos codes restent chiffrés sur cet appareil.\nUn seul compte pour synchroniser et restaurer.';

  @override
  String get registerHaveAccountPrefix => 'Vous avez déjà un compte ? ';

  @override
  String get registerSignInLink => 'Se connecter';

  @override
  String get unlockTitle => 'Coffre-verrouillé';

  @override
  String get unlockBiometricLabel => 'Déverrouiller avec l\'empreinte digitale';

  @override
  String get unlockNotYouPrefix => 'Pas vous ? ';

  @override
  String get unlockSignOutLink => 'Se déconnecter';

  @override
  String get changePasswordFormOldLabel => 'Ancien mot de passe';

  @override
  String get changePasswordFormNewLabel => 'Nouveau mot de passe';

  @override
  String get changePasswordFormConfirmLabel =>
      'Confirmer le nouveau mot de passe';

  @override
  String get homeFavoritesTitle => 'favoris';

  @override
  String get homeAccountsTitle => 'comptes';

  @override
  String get homeSearchHint => 'Rechercher';

  @override
  String get entryMenuAddToFavorites => 'Ajouter aux favoris';

  @override
  String get entryMenuRemoveFromFavorites => 'Retirer des favoris';

  @override
  String get entryMenuUpdate => 'Modifier';

  @override
  String get entryMenuDelete => 'Supprimer';

  @override
  String get confirmDialogTitle => 'Supprimer l\'entrée ?';

  @override
  String get confirmDialogContent =>
      'Cette action supprimera cette entrée TOTP.';

  @override
  String get confirmDialogCancel => 'Annuler';

  @override
  String get confirmDialogConfirm => 'Supprimer';

  @override
  String get clipboardCopiedMessage => 'Copié dans le presse-papiers';

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsLanguageDescription =>
      'Changer la langue de l\'application';

  @override
  String get settingsLanguageRestartRequired =>
      'Vous devez redémarrer l\'application afin d\'appliquer ce paramètre';
}
