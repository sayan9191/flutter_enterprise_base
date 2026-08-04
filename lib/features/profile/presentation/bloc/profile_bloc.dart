import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/bloc/base_bloc.dart';
import '../../../../core/base/bloc/base_event.dart';
import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/logger/app_logger.dart';
import '../../../../core/storage/storage_contracts.dart';

class ProfileLoadRequested extends BaseEvent { const ProfileLoadRequested(); }

class ProfileState extends BaseState {
  const ProfileState({super.status, super.failure, this.email});
  final String? email;
  @override
  List<Object?> get props => [...super.props, email];
}

class ProfileBloc extends BaseBloc<ProfileLoadRequested, ProfileState> {
  ProfileBloc({required SecureStorageService secureStorage, required AppLogger logger})
      : _storage = secureStorage, super(const ProfileState(), logger: logger) {
    on<ProfileLoadRequested>(_onLoad);
  }
  final SecureStorageService _storage;

  Future<void> _onLoad(ProfileLoadRequested e, Emitter<ProfileState> emit) async {
    emit(const ProfileState(status: ViewStatus.loading));
    final email = await _storage.read(StorageKeys.userEmail);
    emit(ProfileState(status: ViewStatus.success, email: email));
  }
}
