import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mayfly Pass'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            tooltip: 'Lock vault',
            onPressed: () => context.read<AuthCubit>().logout(),
          ),
        ],
      ),
      body: const Center(child: Text('Vault unlocked')),
    );
  }
}
