import 'dart:async';

import 'package:mayflypass/core/core.dart';

int currentEpochMs() {
  return (DateTime.now().millisecondsSinceEpoch).floor();
}

final _timerTicker = Stream.periodic(
  const Duration(milliseconds: 250),
  (_) => currentEpochMs,
).asBroadcastStream();

class EpochCubit extends Cubit<int> {
  late final StreamSubscription<int Function()> _sub;
  EpochCubit() : super(currentEpochMs()) {
    _sub = _timerTicker.listen((ts) {
      emit(ts());
    });
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
