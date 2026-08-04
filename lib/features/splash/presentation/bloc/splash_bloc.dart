import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/bloc/base_bloc.dart';
import '../../../../core/base/bloc/base_event.dart';
import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/logger/app_logger.dart';
import '../../../../core/storage/storage_contracts.dart';
import '../../../authentication/domain/repositories/auth_repository.dart';

class SplashStarted extends BaseEvent { const SplashStarted(); }

class SplashState extends BaseState {
  const SplashState({super.status, this.isLoggedIn = false, this.onboardingComplete = false});
  final bool isLoggedIn;
  final bool onboardingComplete;
  @override
  List<Object?> get props => [...super.props, isLoggedIn, onboardingComplete];
}

class SplashBloc extends BaseBloc<SplashStarted, SplashState> {
  SplashBloc({required AuthRepository authRepository, required PreferencesService preferences, required AppLogger logger})
      : _auth = authRepository, _prefs = preferences, super(const SplashState(), logger: logger) {
    on<SplashStarted>(_onStart);
  }
  final AuthRepository _auth;
  final PreferencesService _prefs;

  Future<void> _onStart(SplashStarted e, Emitter<SplashState> emit) async {
    emit(const SplashState(status: ViewStatus.loading));
    final loggedIn = await _auth.isLoggedIn();
    final onboarding = _prefs.getBool(StorageKeys.onboardingComplete) ?? false;
    emit(SplashState(status: ViewStatus.success, isLoggedIn: loggedIn, onboardingComplete: onboarding));
  }
}
