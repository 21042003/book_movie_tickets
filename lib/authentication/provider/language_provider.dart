import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage { en, vi }

final languageProvider = StateProvider<AppLanguage>((ref) => AppLanguage.vi);

extension AppLanguageExtension on AppLanguage {
  String get name {
    switch (this) {
      case AppLanguage.en:
        return 'English';
      case AppLanguage.vi:
        return 'Tiếng Việt';
    }
  }

  String get useButtonText {
    switch (this) {
      case AppLanguage.en:
        return 'Use English';
      case AppLanguage.vi:
        return 'Sử dụng Tiếng Việt';
    }
  }

  // Localized strings for Onboarding
  String get onboardingTitle {
    switch (this) {
      case AppLanguage.en:
        return 'MBooking hello!';
      case AppLanguage.vi:
        return 'Chào mừng đến với MBooking!';
    }
  }

  String get onboardingSubTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Enjoy your favorite movies';
      case AppLanguage.vi:
        return 'Thưởng thức những bộ phim yêu thích của bạn';
    }
  }

  String get signIn {
    switch (this) {
      case AppLanguage.en:
        return 'Sign in';
      case AppLanguage.vi:
        return 'Đăng nhập';
    }
  }

  String get signUp {
    switch (this) {
      case AppLanguage.en:
        return 'Sign up';
      case AppLanguage.vi:
        return 'Đăng ký';
    }
  }

  String get footerText {
    switch (this) {
      case AppLanguage.en:
        return 'By sign in or sign up, you agree to our Terms of Service and Privacy Policy';
      case AppLanguage.vi:
        return 'Bằng cách đăng nhập hoặc đăng ký, bạn đồng ý với Điều khoản dịch vụ và Chính sách bảo mật của chúng tôi';
    }
  }
}
