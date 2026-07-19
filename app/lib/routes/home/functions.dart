part of 'home.dart';

Future<void> _showEntryMenu(
  BuildContext context,
  HomeCubit cubit,
  String id,
  Totp totp,
) {
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
              totp.favorite ? 'Remove from favorites' : 'Add to favorites',
            ),
            onTap: () async {
              Navigator.pop(sheetCtx);
              await cubit.toggleFavorite(id, totp);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Update'),
            onTap: () async {
              Navigator.pop(sheetCtx);
              await router.push('/totp/$id');
              await cubit.load();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Delete'),
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
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete account?'),
      content: const Text('This will remove this TOTP entry.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete'),
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
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 1500),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      backgroundColor: Colors.black87,
      content: Text(
        'Copied to clipboard',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
