import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/logger/app_logger.dart';

class AppBlocObserver extends BlocObserver {
  AppBlocObserver({required AppLogger logger}) : _logger = logger;
  final AppLogger _logger;

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.error('Bloc error in ${bloc.runtimeType}', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
