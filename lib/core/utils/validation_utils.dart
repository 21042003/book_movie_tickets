class ValidationUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập Email';
    }
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email không đúng định dạng';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    
    // Kiểm tra độ dài 8-16 ký tự
    if (value.length < 8 || value.length > 16) {
      return 'Mật khẩu phải từ 8 - 16 ký tự';
    }

    // Kiểm tra bao gồm chữ, số và ký tự đặc biệt
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$');
    if (!passwordRegex.hasMatch(value)) {
      return 'Mật khẩu phải bao gồm chữ, số và ký tự đặc biệt';
    }

    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập đầy đủ họ tên';
    }
    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    if (password != confirmPassword) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }
}
