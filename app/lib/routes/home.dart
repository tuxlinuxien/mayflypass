import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
        actions: [
          IconButton(
            onPressed: () => router.push('/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const Center(child: Text('Vault unlocked')),
      floatingActionButton: IconButton.filled(
        onPressed: () async {
          final refresh = await router.push<bool?>('/totp');
          logger.i(refresh);
          logger.d('total items ${await gloablDB.countStorage()}');
        },
        icon: Icon(Icons.add),
      ),
    );
  }
}
