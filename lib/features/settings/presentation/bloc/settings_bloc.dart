import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/bloc/base_bloc.dart';
import '../../../../core/base/bloc/base_event.dart';
import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/logger/app_logger.dart';
import '../../../../core/services/locale_manager.dart';
import '../../../../core/services/theme_manager.dart';

class SettingsThemeChanged extends BaseEvent {
  const SettingsThemeChanged(this.mode);
  final ThemeMode mode;
  @override
  List<Object?> get props => [mode];
}

class SettingsLocaleChanged extends BaseEvent {
  const SettingsLocaleChanged(this.locale);
  final Locale locale;
  @override
  List<Object?> get props => [locale];
}

class SettingsState extends BaseState {
  const SettingsState({super.status, this.themeMode = ThemeMode.system, this.locale = const Locale('en')});
  final ThemeMode themeMode;
  final Locale locale;
  @override
  List<Object?> get props => [...super.props, themeMode, locale];
}

class SettingsBloc extends BaseBloc<BaseEvent, SettingsState> {
  SettingsBloc({required ThemeManager themeManager, required LocaleManager localeManager, required AppLogger logger})
      : _theme = themeManager, _locale = localeManager,
        super(SettingsState(themeMode: themeManager.themeMode, locale: localeManager.locale), logger: logger) {
    on<SettingsThemeChanged>(_onTheme);
    on<SettingsLocaleChanged>(_onLocale);
  }
  final ThemeManager _theme;
  final LocaleManager _locale;

  Future<void> _onTheme(SettingsThemeChanged e, Emitter<SettingsState> emit) async {
    await _theme.setThemeMode(e.mode);
    emit(SettingsState(status: ViewStatus.success, themeMode: e.mode, locale: state.locale));
  }

  Future<void> _onLocale(SettingsLocaleChanged e, Emitter<SettingsState> emit) async {
    await _locale.setLocale(e.locale);
    emit(SettingsState(status: ViewStatus.success, themeMode: state.themeMode, locale: e.locale));
  }
}
