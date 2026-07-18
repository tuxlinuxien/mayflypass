import 'package:mayflypass/core/core.dart';

void showSuccess(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: .floating,
      content: Text(text),
      backgroundColor: Colors.green,
    ),
  );
}

void showFailure(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: .floating,
      content: Text(text),
      backgroundColor: Colors.red,
    ),
  );
}
