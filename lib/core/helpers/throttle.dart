import 'dart:async';

/// Throttles callbacks to at most once per [duration].
class Throttle {
  Throttle({this.duration = const Duration(milliseconds: 300)});

  final Duration duration;
  Timer? _timer;
  bool _isReady = true;

  void run(void Function() action) {
    if (!_isReady) return;
    _isReady = false;
    action();
    _timer?.cancel();
    _timer = Timer(duration, () => _isReady = true);
  }

  void dispose() {
    _timer?.cancel();
    _isReady = true;
  }
}
