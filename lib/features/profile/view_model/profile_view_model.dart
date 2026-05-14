import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../authentication/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileState {
  final User? user;
  final bool isBiometricEnabled;
  final bool isLoading;

  ProfileState({
    this.user,
    this.isBiometricEnabled = false,
    this.isLoading = false,
  });

  ProfileState copyWith({
    User? user,
    bool? isBiometricEnabled,
    bool? isLoading,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProfileViewModel extends StateNotifier<ProfileState> {
  final AuthRepository _authRepository;

  ProfileViewModel(this._authRepository) : super(ProfileState(user: _authRepository.currentUser));

  void toggleBiometric(bool value) {
    state = state.copyWith(isBiometricEnabled: value);
  }

  void refreshUser() {
    state = state.copyWith(user: _authRepository.currentUser);
  }
}

final profileViewModelProvider = StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
  return ProfileViewModel(ref.watch(authRepositoryProvider));
});
