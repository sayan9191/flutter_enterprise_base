import 'package:flutter_bloc/flutter_bloc.dart';

import '../../errors/error_mapper.dart';
import '../../logger/app_logger.dart';
import 'base_event.dart';
import 'base_state.dart';

/// Base BLoC with logging and centralized error mapping.
abstract class BaseBloc<E extends BaseEvent, S extends BaseState>
    extends Bloc<E, S> {
  BaseBloc(super.initialState, {required AppLogger logger, ErrorMapper? errorMapper})
      : _logger = logger,
        _errorMapper = errorMapper ?? const ErrorMapper();

  final AppLogger _logger;
  final ErrorMapper _errorMapper;

  @override
  void onEvent(E event) {
    super.onEvent(event);
    _logger.bloc(runtimeType.toString(), event.runtimeType.toString());
  }

  @override
  void onChange(Change<S> change) {
    super.onChange(change);
    _logger.bloc(runtimeType.toString(), 'state', change.nextState.status);
  }

  String mapErrorMessage(Object error) =>
      _errorMapper.friendlyMessage(_errorMapper.mapException(error));
}
