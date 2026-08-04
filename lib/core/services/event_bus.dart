import 'dart:async';

/// Simple typed event bus for decoupled cross-feature communication.
class EventBus {
  final _controller = StreamController<dynamic>.broadcast();

  Stream<T> on<T>() => _controller.stream.where((event) => event is T).cast<T>();

  void fire(dynamic event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  Future<void> dispose() => _controller.close();
}
