import 'package:mayflypass/core/core.dart';

class MainContainer extends StatelessWidget {
  final Widget child;
  const MainContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.directional(
        top: DEFAULT_SPACING,
        bottom: DEFAULT_SPACING * 4,
        start: DEFAULT_SPACING,
        end: DEFAULT_SPACING,
      ),
      child: child,
    );
  }
}
