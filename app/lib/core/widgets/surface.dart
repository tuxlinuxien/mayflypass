import 'package:mayflypass/core/core.dart';

class Surface extends StatelessWidget {
  final Widget child;

  const Surface({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(DEFAULT_RADIUS)),
        color: Colors.black,
      ),

      child: child,
    );
  }
}
