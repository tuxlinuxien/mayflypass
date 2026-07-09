import 'package:mayflypass/core/core.dart';

class LockoutAfterItem extends StatelessWidget {
  final Duration value;
  final Function(Duration) onChanged;

  const LockoutAfterItem({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: DEFAULT_SPACING,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              MLabel(text: 'Automatic Lock'),
              Spacer4,
              Text(
                'Lock the application automatically when incative after a certain amount of time',
              ),
            ],
          ),
        ),
        DropdownButton<Duration>(
          items: buildPossibleLockoutDurations(),
          value: value,
          onChanged: (value) => onChanged(value ?? Duration(seconds: 30)),
        ),
      ],
    );
  }
}

List<DropdownMenuItem<Duration>> buildPossibleLockoutDurations() {
  return [
    Duration(seconds: 30),
    Duration(seconds: 60),
    Duration(seconds: 120),
    Duration(seconds: 300),
  ].map((item) {
    return DropdownMenuItem<Duration>(
      value: item,
      child: Text('${item.inSeconds}s'),
    );
  }).toList();
}
