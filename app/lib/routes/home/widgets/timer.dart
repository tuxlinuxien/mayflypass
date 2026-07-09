import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/routes/home/widgets/epoch_cubit.dart';
import 'package:otp/otp.dart';

class Timer extends StatelessWidget {
  final int period;

  const Timer({super.key, required this.period});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EpochCubit(),
      child: BlocBuilder<EpochCubit, int>(
        builder: (context, state) {
          return CircularProgressIndicator(value: _timeLeft(state));
        },
      ),
    );
  }

  int _beginPeriod(int state) {
    return state - (state % (period * 1000));
  }

  int _endPeriod(int state) {
    return _beginPeriod(state) + (period * 1000);
  }

  double _timeLeft(int state) {
    final progress = _endPeriod(state) - state;
    return progress / (period * 1000);
  }
}

class Code extends StatelessWidget {
  final String secret;
  final TotpAlgorithm algorithm;
  final int period;
  final int digits;

  const Code({
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
            _genCode(state),
            style: Theme.of(context).textTheme.headlineMedium,
          );
        },
      ),
    );
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
