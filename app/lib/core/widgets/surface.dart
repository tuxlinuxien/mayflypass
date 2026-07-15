import 'package:mayflypass/core/core.dart';

class Surface extends StatelessWidget {
  final Widget child;

  const Surface({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.InputBackgroundColor,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(9)),
      ),
      child: child,
    );
  }
}
