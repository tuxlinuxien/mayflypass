import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/database/helpers.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/helpers/sync.dart';
import 'package:mayflypass/secure/encryption.dart';

class ImportSecrets extends StatefulWidget {
  const ImportSecrets({super.key});

  @override
  State<ImportSecrets> createState() => _ImportSecretsState();
}

class _ImportSecretsState extends State<ImportSecrets> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: _loading
          ? null
          : () async {
              final total = await _importSecrets();
              if (total == null) {
                return;
              }
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$total secrets have been imported'),
                  backgroundColor: Colors.green,
                ),
              );
            },
      icon: _loading
          ? SizedBox.square(dimension: 24, child: CircularProgressIndicator())
          : Icon(Icons.upload),
    );
  }

  Future<int?> _importSecrets() async {
    setState(() {
      _loading = true;
    });
    try {
      PlatformFile? result = await FilePicker.pickFile(
        type: .custom,
        allowedExtensions: ['json'],
      );
      if (result == null) {
        return null;
      }
      final dynResult = jsonDecode(
        Utf8Decoder().convert(await result.readAsBytes()),
      );
      final mapResult = dynResult as Map<String, dynamic>;
      var totalImported = 0;
      final kek = getGlobalKek()!;
      for (final k in mapResult.keys) {
        try {
          final dbox = DataBox.create()..mergeFromJsonMap(mapResult[k]);
          final (encryptedDek, encryptedPayload) = await encryptDataBox(
            kek,
            dbox,
          );
          await globalDB.upsertLocalStorage(
            LocalStorageData(
              id: k,
              updatedAtMs: generateVersion(),
              deleted: false,
              encryptedDek: encryptedDek,
              encryptedPayload: encryptedPayload,
            ),
          );
          totalImported++;
        } catch (e) {
          logger.e(e);
        }
      }
      await syncLocalAndRemote();
      return totalImported;
    } catch (e) {
      logger.e(e);
    } finally {
      setState(() {
        _loading = false;
      });
    }
    return null;
  }
}
