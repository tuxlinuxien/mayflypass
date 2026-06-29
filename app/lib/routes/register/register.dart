import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mayflypass/api/errors.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/helpers/errors.dart';
import 'package:mayflypass/router.dart';
import 'package:mayflypass/routes/register/form_cubit.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterFormCubit(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterFormCubit, RegisterFormState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.accountCreatedSuccessfully)),
          );
          router.go('/login');
        }
      },
      builder: (context, state) {
        final cubit = context.read<RegisterFormCubit>();
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // email
                TextField(
                  autofocus: true,
                  onChanged: cubit.emailChanged,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.mail),
                    errorText: _emailError(
                      context,
                      state.email.displayError,
                      state.apiEmailError,
                    ),
                  ),
                ),
                Spacer16,
                // password
                TextField(
                  obscureText: _obscurePassword,
                  onChanged: cubit.masterPasswordChanged,
                  decoration: InputDecoration(
                    labelText: l10n.masterPassword,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    errorText: _passwordError(
                      context,
                      state.masterPassword.displayError,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                Spacer16,
                // confirm password
                TextField(
                  obscureText: _obscureConfirm,
                  onChanged: cubit.confirmMasterPasswordChanged,
                  decoration: InputDecoration(
                    labelText: l10n.confirmMasterPassword,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    errorText: _confirmError(
                      context,
                      state.confirmMasterPassword.displayError,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                ),
                Spacer16,
                FilledButton(
                  onPressed: state.status == FormStatus.submitting
                      ? null
                      : cubit.submit,
                  child: state.status == FormStatus.submitting
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(),
                        )
                      : Text(l10n.register),
                ),
                Spacer32,
                const Or(),
                Spacer32,
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(l10n.loginToAccount),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _emailError(
    BuildContext context,
    ValueError? formError,
    FieldError? apiError,
  ) {
    if (formError == null && apiError == null) return null;
    final l10n = AppLocalizations.of(context)!;
    if (formError != null) {
      return switch (formError) {
        ValueRequiredError() => l10n.fieldRequired,
        EmailInvalidError() => l10n.emailInvalid,
        _ => null,
      };
    }
    return switch (apiError) {
      FieldErrorValueDuplicated() => l10n.accountAlreadyExists,
      _ => null,
    };
  }

  String? _passwordError(BuildContext context, ValueError? error) {
    if (error == null) return null;
    final l10n = AppLocalizations.of(context)!;
    return switch (error) {
      ValueRequiredError() => l10n.fieldRequired,
      ValueTooShortError(:final min) => l10n.passwordTooShort(min),
      _ => null,
    };
  }

  String? _confirmError(BuildContext context, ValueError? error) {
    if (error == null) return null;
    final l10n = AppLocalizations.of(context)!;
    return switch (error) {
      ValueMismatchError() => l10n.passwordMismatch,
      _ => null,
    };
  }
}
