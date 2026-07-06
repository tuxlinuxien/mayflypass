import 'package:mayflypass/core/core.dart';

class BiometricUnlockItem extends StatelessWidget {
  final bool value;
  final void Function(bool) onChnaged;

  const BiometricUnlockItem({
    super.key,
    required this.value,
    required this.onChnaged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text('biometric unlock')),
        Checkbox(value: value, onChanged: (value) => onChnaged(value ?? false)),
      ],
    );
  }
}
