import 'package:go_router/go_router.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/forms/totp_issuer.dart';
import 'package:mayflypass/forms/totp_secret.dart';
import 'package:mayflypass/helpers/otpauth.dart';
import 'package:mayflypass/routes/totp/cubit.dart';
import 'package:uuid/uuid.dart';

class TotpPage extends StatelessWidget {
  final UuidValue? id;

  const TotpPage({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return _TotpPage(id: id);
  }
}

class _TotpPage extends StatefulWidget {
  final UuidValue? id;

  const _TotpPage({this.id});

  @override
  State<_TotpPage> createState() => __TotpPageState();
}

class __TotpPageState extends State<_TotpPage> {
  final _issuerController = TextEditingController();
  final _accountController = TextEditingController();
  final _secretController = TextEditingController();
  final _tagsController = TextEditingController();

  @override
  void dispose() {
    _issuerController.dispose();
    _accountController.dispose();
    _secretController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TotpCubit()..load(widget.id),
      child: BlocConsumer<TotpCubit, TotpState>(
        listener: (context, state) {
          switch (state.status) {
            case TotpStatus.success:
              context.pop(true);
            case TotpStatus.ready:
              _issuerController.text = state.issuer.value;
              _accountController.text = state.account.value;
              _secretController.text = state.secret.value;
              _tagsController.text = state.tags.join(',');
            default:
          }
        },
        builder: (context, state) {
          final l10i = AppLocalizations.of(context)!;
          final cubit = context.read<TotpCubit>();
          return Scaffold(
            appBar: AppBar(title: Text(l10i.newTotp)),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  IssuerInput(
                    controller: _issuerController,
                    onChanged: cubit.changeIssuer,
                    errorText: TotpIssuerValueError.toHuman(context, [
                      state.issuer.displayError,
                    ]),
                  ),
                  Spacer16,
                  AccountInput(
                    controller: _accountController,
                    onChanged: cubit.changeAccount,
                  ),
                  Spacer16,
                  SecretInput(
                    controller: _secretController,
                    onChanged: cubit.changeSecret,
                    errorText: TotpSecretValueError.toHuman(context, [
                      state.secret.displayError,
                    ]),
                  ),
                  Spacer16,
                  AlgorithmSelector(
                    value: state.algorithm,
                    onChanged: cubit.changeAlgorithm,
                  ),
                  Spacer16,
                  DigitsSelector(
                    value: state.digits,
                    onChanged: cubit.changeDigits,
                  ),
                  Spacer16,
                  PeriodSelector(
                    value: state.period,
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
                    controller: _tagsController,
                    onChanged: cubit.changeTags,
                  ),
                  Spacer16,
                  FilledButton(onPressed: cubit.submit, child: Text('Save')),
                  Spacer32,
                  OutlinedButton(
                    onPressed: () async {
                      final code = await context.push<String?>('/totp-scanner');
                      final otpA = OtpAuthResult.parse(code);
                      if (otpA == null) {
                        return;
                      }
                      cubit.changeIssuer(otpA.issuer);
                      cubit.changeAccount(otpA.account);
                      cubit.changeSecret(otpA.secret);
                      cubit.changeAlgorithm(otpA.algorithm);
                      cubit.changeDigits(otpA.digits);
                      cubit.changePeriod(otpA.period);
                    },
                    child: Icon(Icons.qr_code_2),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class IssuerInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? errorText;

  const IssuerInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Issuer', errorText: errorText),
      controller: controller,
      onChanged: onChanged,
    );
  }
}

class AccountInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? errorText;

  const AccountInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Account', errorText: errorText),
      controller: controller,
      onChanged: onChanged,
    );
  }
}

class SecretInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? errorText;

  const SecretInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Secret', errorText: errorText),
      controller: controller,
      onChanged: onChanged,
    );
  }
}

class AlgorithmSelector extends StatelessWidget {
  final TotpAlgorithm? value;
  final Function(TotpAlgorithm?) onChanged;

  const AlgorithmSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text('Algorithm'),
        DropdownButton<TotpAlgorithm>(
          value: value,
          items: TotpAlgorithm.values.map((e) {
            return DropdownMenuItem(value: e, child: Text(e.name));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class DigitsSelector extends StatelessWidget {
  final int? value;
  final Function(int?) onChanged;

  const DigitsSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text('Digits'),
        DropdownButton<int>(
          value: value,
          items: [6, 7, 8].map((e) {
            return DropdownMenuItem(value: e, child: Text(e.toString()));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class PeriodSelector extends StatelessWidget {
  final int? value;
  final Function(int?) onChanged;

  const PeriodSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10i = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text('Period'),
        DropdownButton<int>(
          value: value,
          items: [15, 30, 60].map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(l10i.totpPeriodSeconds(e)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
