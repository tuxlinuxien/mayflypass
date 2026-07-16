import 'package:go_router/go_router.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/forms/totp_issuer.dart';
import 'package:mayflypass/forms/totp_secret.dart';
import 'package:mayflypass/routes/totp/cubit.dart';

class TotpManualPage extends StatelessWidget {
  final String? id;

  const TotpManualPage({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return _TotpManualPage(id: id);
  }
}

class _TotpManualPage extends StatefulWidget {
  final String? id;

  const _TotpManualPage({this.id});

  @override
  State<_TotpManualPage> createState() => __TotpManualPageState();
}

class __TotpManualPageState extends State<_TotpManualPage> {
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
            case TotpStatus.loaded:
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
            appBar: AppBar(
              title: Text(widget.id == null ? 'Add account' : 'Update account'),
            ),
            body: SingleChildScrollView(
              child: MainContainer(
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: <Widget>[
                    IssuerInput(
                      controller: _issuerController,
                      onChanged: cubit.changeIssuer,
                      errorText: TotpIssuerValueError.toHuman(context, [
                        state.issuer.displayError,
                      ]),
                    ),
                    SpacerFormField,
                    AccountInput(
                      controller: _accountController,
                      onChanged: cubit.changeAccount,
                    ),
                    SpacerFormField,
                    SecretInput(
                      controller: _secretController,
                      onChanged: cubit.changeSecret,
                      errorText: TotpSecretValueError.toHuman(context, [
                        state.secret.displayError,
                      ]),
                    ),
                    SpacerSection,
                    AlgorithmSelector(
                      value: state.algorithm,
                      onChanged: cubit.changeAlgorithm,
                    ),
                    SpacerFormField,
                    DigitsSelector(
                      value: state.digits,
                      onChanged: cubit.changeDigits,
                    ),
                    SpacerFormField,
                    PeriodSelector(
                      value: state.period,
                      onChanged: cubit.changePeriod,
                    ),
                    SpacerSection,
                    MTextFormField(
                      labelText: 'Tags',
                      controller: _tagsController,
                      onChanged: cubit.changeTags,
                    ),
                    SpacerSection,
                    FilledButton(onPressed: cubit.submit, child: Text('Save')),
                  ],
                ),
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
    return MTextFormField(
      labelText: 'Issuer',
      errorText: errorText,
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
    return MTextFormField(
      labelText: 'Account',
      hintText: '(optional)',
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
    return MTextFormField(
      labelText: 'Secret',
      errorText: errorText,
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
        MLabel(text: 'Algorithm'),
        Spacer4,
        DropdownButtonFormField<TotpAlgorithm>(
          decoration: InputDecoration(border: OutlineInputBorder()),
          initialValue: value,
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
        MLabel(text: 'Digits'),
        Spacer4,
        DropdownButtonFormField<int>(
          decoration: InputDecoration(border: OutlineInputBorder()),
          initialValue: value,
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
        MLabel(text: 'Period'),
        Spacer4,
        DropdownButtonFormField<int>(
          initialValue: value,
          decoration: InputDecoration(border: OutlineInputBorder()),
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
