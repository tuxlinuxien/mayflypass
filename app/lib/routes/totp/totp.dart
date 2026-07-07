import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/routes/totp/cubit.dart';
import 'package:uuid/uuid.dart';

class TotpPage extends StatelessWidget {
  final UuidValue? id;

  const TotpPage({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TotpCubit()..load(id),
      child: BlocBuilder<TotpCubit, TotpState>(
        builder: (context, state) {
          final l10i = AppLocalizations.of(context)!;
          final cubit = context.read<TotpCubit>();
          return Scaffold(
            appBar: AppBar(title: Text(l10i.newTotp)),
            body: SingleChildScrollView(
              child: Column(crossAxisAlignment: .stretch, children: [
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
