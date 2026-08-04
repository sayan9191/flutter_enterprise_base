import 'package:get_it/get_it.dart';

import '../../config/env/environment_manager.dart';
import '../../config/router/auth_guard.dart';
import '../../features/authentication/data/datasources/auth_local_data_source.dart';
import '../../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/usecases/forgot_password_usecase.dart';
import '../../features/authentication/domain/usecases/login_usecase.dart';
import '../../features/authentication/domain/usecases/logout_usecase.dart';
import '../../features/authentication/domain/usecases/register_usecase.dart';
import '../../features/authentication/domain/usecases/reset_password_usecase.dart';
import '../../features/authentication/domain/usecases/verify_otp_usecase.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_users_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/splash/presentation/bloc/splash_bloc.dart';
import '../analytics/analytics_service.dart';
import '../errors/global_error_handler.dart';
import '../logger/app_logger.dart';
import '../network/network.dart';
import '../network/network_info.dart';
import '../permissions/permission_manager.dart';
import '../security/security_service.dart';
import '../services/app_lifecycle_manager.dart';
import '../services/connectivity_manager.dart';
import '../services/event_bus.dart';
import '../services/locale_manager.dart';
import '../services/navigation_service.dart';
import '../services/session_manager.dart';
import '../services/startup_service.dart';
import '../services/theme_manager.dart';
import '../storage/hive_storage_service.dart';
import '../storage/preferences_service.dart';
import '../storage/secure_storage_service.dart';
import '../storage/storage_contracts.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies({required String envFile}) async {
  if (getIt.isRegistered<AppLogger>()) {
    await getIt.reset();
  }

  getIt.registerSingleton(EnvironmentManager.instance);
  getIt.registerLazySingleton<EventBus>(EventBus.new);
  getIt.registerLazySingleton<AppLogger>(() => AppLogger(enabled: true));

  getIt.registerLazySingleton<HiveStorageService>(
    () => HiveStorageService(logger: getIt()),
  );
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(logger: getIt()),
  );
  getIt.registerLazySingleton<PreferencesService>(
    () => PreferencesServiceImpl(logger: getIt()),
  );
  getIt.registerLazySingleton<NetworkInfo>(NetworkInfoImpl.new);
  getIt.registerLazySingleton<NavigationService>(
    () => NavigationService(logger: getIt()),
  );
  getIt.registerLazySingleton<ThemeManager>(
    () => ThemeManager(preferences: getIt(), logger: getIt()),
  );
  getIt.registerLazySingleton<LocaleManager>(
    () => LocaleManager(preferences: getIt(), logger: getIt()),
  );
  getIt.registerLazySingleton<ConnectivityManager>(
    () => ConnectivityManager(networkInfo: getIt(), logger: getIt()),
  );
  getIt.registerLazySingleton<SecurityService>(
    () => SecurityService(logger: getIt()),
  );
  getIt.registerLazySingleton<PermissionManager>(
    () => PermissionManager(logger: getIt()),
  );
  getIt.registerLazySingleton<AnalyticsService>(
    () => AnalyticsService(logger: getIt()),
  );
  getIt.registerLazySingleton<GlobalErrorHandler>(
    () => GlobalErrorHandler(logger: getIt()),
  );

  getIt.registerLazySingleton<StartupService>(
    () => StartupService(
      environmentManager: getIt(),
      hiveStorage: getIt(),
      preferences: getIt(),
      themeManager: getIt(),
      localeManager: getIt(),
      connectivityManager: getIt(),
      securityService: getIt(),
      permissionManager: getIt(),
      analyticsService: getIt(),
      logger: getIt(),
    ),
  );

  await getIt<StartupService>().initialize(envFile: envFile);

  getIt.unregister<AppLogger>();
  getIt.registerLazySingleton<AppLogger>(
    () => AppLogger(
      enabled: getIt<EnvironmentManager>().environment.enableLogging,
    ),
  );

  getIt.registerLazySingleton<SessionManager>(
    () => SessionManager(
      secureStorage: getIt(),
      preferences: getIt(),
      apiClientProvider: () => getIt<ApiClient>(),
      logger: getIt(),
      eventBus: getIt(),
    ),
  );
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      environment: getIt<EnvironmentManager>().environment,
      environmentManager: getIt<EnvironmentManager>(),
      secureStorage: getIt(),
      sessionManager: getIt(),
      networkInfo: getIt(),
      logger: getIt(),
    ),
  );
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(apiClient: getIt(), logger: getIt()),
  );
  getIt.registerLazySingleton<AppLifecycleManager>(
    () => AppLifecycleManager(sessionManager: getIt(), logger: getIt())..initialize(),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: getIt()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: getIt(), preferences: getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: getIt(), local: getIt(), sessionManager: getIt()),
  );
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton<AuthGuard>(() => AuthGuard(authRepository: getIt()));
  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt(),
      registerUseCase: getIt(),
      forgotPasswordUseCase: getIt(),
      verifyOtpUseCase: getIt(),
      resetPasswordUseCase: getIt(),
      logoutUseCase: getIt(),
      logger: getIt(),
    ),
  );

  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiService: getIt()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remote: getIt()),
  );
  getIt.registerLazySingleton(() => GetUsersUseCase(getIt()));
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(getUsersUseCase: getIt(), logger: getIt()),
  );
  getIt.registerFactory<SplashBloc>(
    () => SplashBloc(authRepository: getIt(), preferences: getIt(), logger: getIt()),
  );
  getIt.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(preferences: getIt(), logger: getIt()),
  );
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(secureStorage: getIt(), logger: getIt()),
  );
  getIt.registerLazySingleton<SettingsBloc>(
    () => SettingsBloc(themeManager: getIt(), localeManager: getIt(), logger: getIt()),
  );
}
