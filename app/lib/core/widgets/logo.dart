import 'package:mayflypass/core/core.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.PrimaryColor, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.asset('assets/logo-1024-1024.png'),
      ),
    );
  }
}
