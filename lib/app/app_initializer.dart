import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/flavors/flavor_config.dart';
import '../core/di/injection.dart';
import '../core/logger/app_logger.dart';
import '../core/errors/global_error_handler.dart';
import 'app_bloc_observer.dart';

Future<void> initializeApp({required AppFlavor flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = FlavorConfig.fromFlavor(flavor);
  await configureDependencies(envFile: config.envFile);
  Bloc.observer = AppBlocObserver(logger: getIt<AppLogger>());
  getIt<GlobalErrorHandler>().initialize();
}
