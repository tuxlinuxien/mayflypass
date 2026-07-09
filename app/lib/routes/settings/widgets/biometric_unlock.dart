import 'dart:io';

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
      spacing: DEFAULT_SPACING,
      children: [
        Expanded(
          child: Opacity(
            opacity: (Platform.isAndroid || Platform.isIOS) ? 1.0 : 0.5,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                MLabel(text: 'Biometric Unlock'),
                Spacer4,
                Text('Unlock the application using your fingerprint'),
              ],
            ),
          ),
        ),
        Switch(
          value: value,
          // only allow this feature on mobile devices
          onChanged: (Platform.isAndroid || Platform.isIOS)
              ? (value) => onChnaged(value)
              : null,
        ),
      ],
    );
  }
}
