import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/validation_utils.dart';
import '../repository/auth_repository.dart';
import '../../core/localization/language_provider.dart';

class AuthState {
  final bool isLoading;
  final String? emailError;
  final String? passwordError;
  final String? fullNameError;
  final String? confirmPasswordError;
  final String? generalError;
  final bool isSuccess;

  AuthState({
    this.isLoading = false,
    this.emailError,
    this.passwordError,
    this.fullNameError,
    this.confirmPasswordError,
    this.generalError,
    this.isSuccess = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? emailError,
    String? passwordError,
    String? fullNameError,
    String? confirmPasswordError,
    String? generalError,
    bool? isSuccess,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      emailError: emailError,
      passwordError: passwordError,
      fullNameError: fullNameError,
      confirmPasswordError: confirmPasswordError,
      generalError: generalError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final Ref ref;

  AuthViewModel(this._authRepository, this.ref) : super(AuthState());

  void signIn(String email, String password) async {
    final tr = ref.read(translationsProvider);
    final emailErr = ValidationUtils.validateEmail(email, tr);
    final passwordErr = ValidationUtils.validatePassword(password, tr);

    if (emailErr != null || passwordErr != null) {
      state = state.copyWith(
        emailError: emailErr,
        passwordError: passwordErr,
      );
      return;
    }

    state = state.copyWith(isLoading: true, emailError: null, passwordError: null, generalError: null);
    
    try {
      await _authRepository.signIn(email, password);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, generalError: e.toString());
    }
  }

  void signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final tr = ref.read(translationsProvider);
    final nameErr = ValidationUtils.validateFullName(fullName, tr);
    final emailErr = ValidationUtils.validateEmail(email, tr);
    final passwordErr = ValidationUtils.validatePassword(password, tr);
    final confirmErr = ValidationUtils.validateConfirmPassword(password, confirmPassword, tr);

    if (nameErr != null || emailErr != null || passwordErr != null || confirmErr != null) {
      state = state.copyWith(
        fullNameError: nameErr,
        emailError: emailErr,
        passwordError: passwordErr,
        confirmPasswordError: confirmErr,
      );
      return;
    }

    state = state.copyWith(isLoading: true, fullNameError: null, emailError: null, passwordError: null, confirmPasswordError: null, generalError: null);
    
    try {
      await _authRepository.signUp(email, password, fullName);
      // Đăng xuất ngay lập tức để không bị tự động nhảy vào HomeScreen
      await _authRepository.signOut();
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, generalError: e.toString());
    }
  }

  void recoverPassword(String email) async {
    final tr = ref.read(translationsProvider);
    final emailErr = ValidationUtils.validateEmail(email, tr);

    if (emailErr != null) {
      state = state.copyWith(emailError: emailErr);
      return;
    }

    state = state.copyWith(isLoading: true, emailError: null, generalError: null);
    
    try {
      await _authRepository.recoverPassword(email);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, generalError: e.toString());
    }
  }

  void signOut() async {
    await _authRepository.signOut();
    state = AuthState();
  }

  void clearErrors() {
    state = AuthState();
  }
}

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(ref.watch(authRepositoryProvider), ref);
});
