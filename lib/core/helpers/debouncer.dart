import 'dart:async';

import '../constants/app_constants.dart';

/// Debounces rapid callbacks (e.g. search input).
class Debouncer {
  Debouncer({this.duration = const Duration(milliseconds: AppConstants.debounceMilliseconds)});

  final Duration duration;
  Timer? _timer;

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  void cancel() => _timer?.cancel();

  void dispose() => _timer?.cancel();
}
