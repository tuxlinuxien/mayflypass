import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/secure/encryption.dart';

class BackupSecrets extends StatefulWidget {
  const BackupSecrets({super.key});

  @override
  State<BackupSecrets> createState() => _BackupSecretsState();
}

class _BackupSecretsState extends State<BackupSecrets> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final l10i = AppLocalizations.of(context)!;
    return IconButton.filled(
      onPressed: _loading
          ? null
          : () async {
              final ok = await _exportSecrets();
              if (!ok) {
                return;
              }
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10i.secretsExported),
                  backgroundColor: Colors.green,
                ),
              );
            },
      icon: _loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            )
          : const Icon(Icons.download),
    );
  }

  Future<bool> _exportSecrets() async {
    setState(() {
      _loading = true;
    });
    try {
      final name =
          'mayflypass_export_${DateTime.now().millisecondsSinceEpoch}.json';
      final kek = getGlobalKek()!;
      final items = await globalDB.selectLocalStorage(withDeleted: false);
      final output = <String, Map<String, dynamic>>{};
      for (final item in items) {
        try {
          output[item.id] = (await decryptDataBox(
            kek,
            item.encryptedDek,
            item.encryptedPayload,
          )).writeToJsonMap();
        } catch (e) {
          logger.e(e);
        }
      }
      final content = jsonEncode(output);
      return await FilePicker.saveFile(
            fileName: name,
            type: FileType.any,
            bytes: Utf8Encoder().convert(content),
          ) !=
          null;
    } catch (e) {
      logger.e(e);
      return false;
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
