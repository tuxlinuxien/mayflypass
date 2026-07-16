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
      items: [
        DropdownMenuItem(value: Duration(minutes: 1), child: Text('1m')),
        DropdownMenuItem(value: Duration(minutes: 5), child: Text('5m')),
        DropdownMenuItem(value: Duration(minutes: 15), child: Text('15m')),
      ],
      onChanged: (v) => onChanged(v ?? Duration(minutes: 1)),
    );
  }
}
