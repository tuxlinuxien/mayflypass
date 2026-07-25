import 'package:mayflypass/core/core.dart';

class LocaleDropdown extends StatelessWidget {
  final String? value;
  final Function(String?) onChanged;

  const LocaleDropdown({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      items: const [
        DropdownMenuItem(value: 'en', child: Text('English')),
        DropdownMenuItem(value: 'fr', child: Text('Français')),
      ],
      onChanged: onChanged,
    );
  }
}
