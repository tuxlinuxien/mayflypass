part of 'home.dart';

Future<void> _showEntryMenu(
  BuildContext context,
  HomeCubit cubit,
  String id,
  Totp totp,
) {
  final l10n = AppLocalizations.of(context)!;
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppTheme.AppBackgroundColor,
    builder: (sheetCtx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(totp.favorite ? Icons.star : Icons.star_border),
            title: Text(
              totp.favorite
                  ? l10n.entryMenuRemoveFromFavorites
                  : l10n.entryMenuAddToFavorites,
            ),
            onTap: () async {
              Navigator.pop(sheetCtx);
              await cubit.toggleFavorite(id, totp);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(l10n.entryMenuUpdate),
            onTap: () async {
              Navigator.pop(sheetCtx);
              await router.push('/totp/$id');
              await cubit.load();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(l10n.entryMenuDelete),
            onTap: () async {
              Navigator.pop(sheetCtx);
              final confirmed = await _confirmDelete(context);
              if (confirmed) await cubit.delete(id);
            },
          ),
        ],
      ),
    ),
  );
}

Future<bool> _confirmDelete(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.confirmDialogTitle),
      content: Text(l10n.confirmDialogContent),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.confirmDialogCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.confirmDialogConfirm),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<void> _showCopyCode(BuildContext context, Totp totp) async {
  final code = getCode(
    secret: totp.secret,
    algorithm: totp.algorithm,
    digits: totp.digits,
    period: totp.period,
    ms: DateTime.now().millisecondsSinceEpoch,
  );
  await Clipboard.setData(ClipboardData(text: code));
  if (!context.mounted) {
    return;
  }
  final l10n = AppLocalizations.of(context)!;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 1500),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      backgroundColor: Colors.black87,
      content: Text(
        l10n.clipboardCopiedMessage,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
