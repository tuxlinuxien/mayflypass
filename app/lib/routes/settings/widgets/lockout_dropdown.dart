import 'package:mayflypass/core/core.dart';

class LockoutAfterDropdown extends StatelessWidget {
  final Duration value;
  final Function(Duration) onChanged;

  const LockoutAfterDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Duration>(
      value: value,
      items: LOCK_AFTER_CHOICES
          .map(
            (e) => DropdownMenuItem(value: e, child: Text('${e.inMinutes}m')),
          )
          .toList(),
      onChanged: (v) => onChanged(v ?? LOCK_AFTER_CHOICES[0]),
    );
  }
}
