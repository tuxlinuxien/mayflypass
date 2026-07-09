import 'package:mayflypass/core/core.dart';

class MLabel extends StatelessWidget {
  final String text;

  const MLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class MTextFormField extends StatelessWidget {
  final String? labelText;
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final Function(String)? onChanged;

  const MTextFormField({
    super.key,
    this.labelText,
    this.initialValue,
    this.controller,
    this.hintText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: <Widget?>[
        labelText != null ? MLabel(text: labelText ?? '') : null,
        labelText != null ? Spacer4 : null,
        TextFormField(
          key: key,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          initialValue: initialValue,
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
        ),
      ].nonNulls.toList(),
    );
  }
}
