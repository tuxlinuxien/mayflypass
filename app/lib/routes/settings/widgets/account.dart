import 'package:mayflypass/core/core.dart';

class AccountItem extends StatelessWidget {
  final String email;

  const AccountItem({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        MLabel(text: 'E-mail'),
        Spacer4,
        Text(email),
      ],
    );
  }
}
