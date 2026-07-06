import 'package:mayflypass/core/core.dart';

class AccountItem extends StatelessWidget {
  final String email;

  const AccountItem({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [Text('account'), Text(email)],
    );
  }
}
