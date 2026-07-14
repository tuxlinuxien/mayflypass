import 'package:mayflypass/core/core.dart';

class Logo extends StatelessWidget {
  final double size;

  const Logo({super.key, this.size = 90});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.PrimaryColor, width: 1),
          borderRadius: BorderRadius.circular((size * 0.25).floor().toDouble()),
        ),
        child: Image.asset('assets/logo-1024-1024.png'),
      ),
    );
  }
}
