import 'package:mayflypass/core/core.dart';

class MainContainer extends StatelessWidget {
  final Widget child;
  const MainContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.directional(
        top: 36,
        bottom: 36,
        start: 26,
        end: 26,
      ),
      child: child,
    );
  }
}

class MainCenterScrollable extends StatelessWidget {
  final Widget child;

  const MainCenterScrollable({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: MainContainer(child: child)),
          ),
        );
      },
    );
  }
}
