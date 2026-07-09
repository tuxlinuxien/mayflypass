import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/routes/home/widgets/epoch_cubit.dart';

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
