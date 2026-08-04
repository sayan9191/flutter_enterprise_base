import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/bloc/base_bloc.dart';
import '../../../../core/base/bloc/base_event.dart';
import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/logger/app_logger.dart';
import '../../../../core/storage/storage_contracts.dart';

class OnboardingCompleteRequested extends BaseEvent { const OnboardingCompleteRequested(); }

class OnboardingBloc extends BaseBloc<OnboardingCompleteRequested, BaseState> {
  OnboardingBloc({required PreferencesService preferences, required AppLogger logger})
      : _prefs = preferences, super(const BaseStateImpl(), logger: logger) {
    on<OnboardingCompleteRequested>(_onComplete);
  }
  final PreferencesService _prefs;

  Future<void> _onComplete(OnboardingCompleteRequested e, Emitter<BaseState> emit) async {
    await _prefs.setBool(StorageKeys.onboardingComplete, true);
    emit(const BaseStateImpl(status: ViewStatus.success));
  }
}

class BaseStateImpl extends BaseState {
  const BaseStateImpl({super.status, super.failure});
}
