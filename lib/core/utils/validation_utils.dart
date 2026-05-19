import '../localization/language_provider.dart';

class ValidationUtils {
  static String? validateEmail(String? value, AppLanguage tr) {
    if (value == null || value.trim().isEmpty) {
      return tr.errEmailEmpty;
    }
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegex.hasMatch(value.trim())) {
      return tr.errEmailInvalid;
    }
    return null;
  }

  static String? validatePassword(String? value, AppLanguage tr) {
    if (value == null || value.isEmpty) {
      return tr.errPasswordEmpty;
    }
    
    // Kiểm tra độ dài 8-16 ký tự
    if (value.length < 8 || value.length > 16) {
      return tr.errPasswordLength;
    }

    // Kiểm tra bao gồm chữ, số và ký tự đặc biệt
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$');
    if (!passwordRegex.hasMatch(value)) {
      return tr.errPasswordComplexity;
    }

    return null;
  }

  static String? validateFullName(String? value, AppLanguage tr) {
    if (value == null || value.trim().isEmpty) {
      return tr.errFullNameEmpty;
    }
    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword, AppLanguage tr) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return tr.errConfirmPasswordEmpty;
    }
    if (password != confirmPassword) {
      return tr.errPasswordNotMatch;
    }
    return null;
  }
}
