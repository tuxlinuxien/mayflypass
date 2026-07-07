import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/forms/totp_issuer.dart';
import 'package:mayflypass/forms/totp_secret.dart';
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
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Issuer',
                      errorText: TotpIssuerValueError.toHuman(context, [
                        state.issuer.displayError,
                      ]),
                    ),
                    initialValue: state.issuer.value,
                    onChanged: cubit.changeIssuer,
                  ),
                  Spacer16,
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Account'),
                    initialValue: state.account.value,
                    onChanged: cubit.changeAccount,
                  ),
                  Spacer16,
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Secret',
                      errorText: TotpSecretValueError.toHuman(context, [
                        state.secret.displayError,
                      ]),
                    ),
                    initialValue: state.secret.value,
                    onChanged: cubit.changeSecret,
                  ),
                  Spacer16,
                  Text('Algorithm'),
                  DropdownButton<TotpAlgorithm>(
                    value: state.algorithm,
                    items: TotpAlgorithm.values.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e.name));
                    }).toList(),
                    onChanged: cubit.changeAlgorithm,
                  ),
                  Spacer16,
                  Text('Digits'),
                  DropdownButton<int>(
                    value: state.digits,
                    items: [6, 8].map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e.toString()),
                      );
                    }).toList(),
                    onChanged: cubit.changeDigits,
                  ),
                  Spacer16,
                  Text('Period'),
                  DropdownButton<int>(
                    value: state.period,
                    items: [30, 60].map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(l10i.totpPeriodSeconds(e)),
                      );
                    }).toList(),
                    onChanged: cubit.changePeriod,
                  ),
                  Spacer16,
                  Row(
                    children: [
                      Expanded(child: Text('Favorite')),
                      Checkbox(
                        value: state.favorite,
                        onChanged: cubit.changeFavorite,
                      ),
                    ],
                  ),
                  Spacer16,
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Tags'),
                    initialValue: state.tags.join(','),
                    onChanged: cubit.changeTags,
                  ),
                  Spacer16,
                  FilledButton(onPressed: cubit.submit, child: Text('Save')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
