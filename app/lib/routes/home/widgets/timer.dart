import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/routes/home/widgets/epoch_cubit.dart';

class Timer extends StatelessWidget {
  final int period;

  const Timer({super.key, required this.period});

  @override
  Widget build(BuildContext context) {
    final double size = 40;
    return BlocProvider(
      create: (context) => EpochCubit(),
      child: BlocBuilder<EpochCubit, int>(
        builder: (context, state) {
          return SizedBox(
            height: size,
            width: size,
            child: Stack(
              children: [
                SizedBox(
                  height: size,
                  width: size,
                  child: CircularProgressIndicator(
                    value: 1,
                    color: AppTheme.BrightColor.withValues(alpha: 0.2),
                  ),
                ),
                SizedBox(
                  height: size,
                  width: size,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(end: _progressLeft(state)),
                    duration: const Duration(milliseconds: 499),
                    curve: Curves.linear,
                    builder: (context, value, _) =>
                        CircularProgressIndicator(value: value),
                  ),
                ),
                SizedBox(
                  height: size,
                  width: size,
                  child: Center(child: Text('${_timeLeft(state)}')),
                ),
              ],
            ),
          );
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

  double _progressLeft(int state) {
    final progress = _endPeriod(state) - state;
    return progress / (period * 1000);
  }

  int _timeLeft(int state) {
    final left = (_endPeriod(state) - state).floor();
    return ((left < 0 ? 0 : left) / 1000).toInt();
  }
}
