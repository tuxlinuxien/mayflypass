import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/routes/home/widgets/epoch_cubit.dart';
import 'package:otp/otp.dart';

class OTPCode extends StatelessWidget {
  final String secret;
  final TotpAlgorithm algorithm;
  final int period;
  final int digits;

  const OTPCode({
    super.key,
    required this.secret,
    required this.algorithm,
    required this.digits,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EpochCubit(),
      child: BlocBuilder<EpochCubit, int>(
        builder: (context, state) {
          return Text(
            _splitCode(_genCode(state)),
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight(600),
              letterSpacing: 4,
              fontFamily: 'Roboto Mono',
            ),
          );
        },
      ),
    );
  }

  String _splitCode(String code) {
    if (code.length <= 3) return code;
    return '${code.substring(0, 3)} ${code.substring(3)}';
  }

  String _genCode(int state) {
    final algo = switch (algorithm) {
      .SHA1 => Algorithm.SHA1,
      .SHA256 => Algorithm.SHA256,
      .SHA512 => Algorithm.SHA512,
      _ => throw UnimplementedError(),
    };

    return OTP.generateTOTPCodeString(
      secret,
      state,
      algorithm: algo,
      interval: period,
      length: digits,
      isGoogle: true,
    );
  }
}
