import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage { en, vi }

final languageProvider = StateProvider<AppLanguage>((ref) => AppLanguage.vi);

final translationsProvider = Provider<AppLanguage>((ref) {
  return ref.watch(languageProvider);
});

extension AppLanguageExtension on AppLanguage {
  String get name {
    switch (this) {
      case AppLanguage.en: return 'English';
      case AppLanguage.vi: return 'Tiếng Việt';
    }
  }

  // Common
  String get seeAll => this == AppLanguage.vi ? 'Xem tất cả' : 'See all';
  String get total => this == AppLanguage.vi ? 'Tổng cộng' : 'Total';
  String get continueBtn => this == AppLanguage.vi ? 'Tiếp tục' : 'Continue';
  String get search => this == AppLanguage.vi ? 'Tìm kiếm' : 'Search';
  String get email => this == AppLanguage.vi ? 'Email' : 'Email';
  String get password => this == AppLanguage.vi ? 'Mật khẩu' : 'Password';
  String get fullName => this == AppLanguage.vi ? 'Họ và tên' : 'Full Name';
  String get confirmPassword => this == AppLanguage.vi ? 'Xác nhận mật khẩu' : 'Confirm Password';

  // Bottom Nav
  String get home => this == AppLanguage.vi ? 'Trang chủ' : 'Home';
  String get ticket => this == AppLanguage.vi ? 'Vé' : 'Ticket';
  String get movie => this == AppLanguage.vi ? 'Phim' : 'Movie';
  String get profile => this == AppLanguage.vi ? 'Cá nhân' : 'Profile';

  // Home Screen
  String get hello => this == AppLanguage.vi ? 'Chào' : 'Hello';
  String get welcomeBack => this == AppLanguage.vi ? 'Chào mừng trở lại' : 'Welcome back';
  String get nowPlaying => this == AppLanguage.vi ? 'Đang chiếu' : 'Now playing';
  String get comingSoon => this == AppLanguage.vi ? 'Sắp chiếu' : 'Coming soon';
  String get promoDiscount => this == AppLanguage.vi ? 'Khuyến mãi' : 'Promo & Discount';

  // Movie Detail
  String get storyline => this == AppLanguage.vi ? 'Nội dung' : 'Storyline';
  String get director => this == AppLanguage.vi ? 'Đạo diễn' : 'Director';
  String get actor => this == AppLanguage.vi ? 'Diễn viên' : 'Actor';
  String get cinema => this == AppLanguage.vi ? 'Rạp chiếu' : 'Cinema';
  String get selectDate => this == AppLanguage.vi ? 'Chọn ngày' : 'Select Date';
  String get selectShowtime => this == AppLanguage.vi ? 'Chọn suất chiếu' : 'Select Showtime';
  String get notYetReleased => this == AppLanguage.vi ? 'Phim chưa khởi chiếu' : 'Not yet released';
  String get noShowtimes => this == AppLanguage.vi ? 'Hết suất chiếu' : 'No showtimes available';

  // Seat Selection
  String get selectSeat => this == AppLanguage.vi ? 'Chọn ghế' : 'Select seat';
  String get available => this == AppLanguage.vi ? 'Trống' : 'Available';
  String get reserved => this == AppLanguage.vi ? 'Đã đặt' : 'Reserved';
  String get selected => this == AppLanguage.vi ? 'Đang chọn' : 'Selected';
  String get buyTicket => this == AppLanguage.vi ? 'Đặt vé' : 'Buy ticket';

  // Payment
  String get payment => this == AppLanguage.vi ? 'Thanh toán' : 'Payment';
  String get orderId => this == AppLanguage.vi ? 'Mã đơn hàng' : 'Order ID';
  String get seat => this == AppLanguage.vi ? 'Ghế' : 'Seat';
  String get discountCode => this == AppLanguage.vi ? 'Mã giảm giá' : 'Discount code';
  String get apply => this == AppLanguage.vi ? 'Áp dụng' : 'Apply';
  String get paymentMethod => this == AppLanguage.vi ? 'Phương thức thanh toán' : 'Payment Method';
  String get completePaymentIn => this == AppLanguage.vi ? 'Hoàn tất thanh toán trong' : 'Complete your payment in';

  // My Ticket
  String get myTicket => this == AppLanguage.vi ? 'Vé của tôi' : 'My ticket';
  String get section => this == AppLanguage.vi ? 'Khu vực' : 'Section';
  String get showQrCode => this == AppLanguage.vi ? 'Đưa mã này cho nhân viên soát vé' : 'Show this QR code to the ticket counter to receive your ticket';

  // Profile
  String get paymentHistory => this == AppLanguage.vi ? 'Lịch sử thanh toán' : 'Payment history';
  String get changeLanguage => this == AppLanguage.vi ? 'Đổi ngôn ngữ' : 'Change language';
  String get changePassword => this == AppLanguage.vi ? 'Đổi mật khẩu' : 'Change password';
  String get faceId => this == AppLanguage.vi ? 'Xác thực sinh trắc học' : 'Face ID / Touch ID';
  String get signOut => this == AppLanguage.vi ? 'Đăng xuất' : 'Sign Out';
  String get darkMode => this == AppLanguage.vi ? 'Chế độ tối' : 'Dark Mode';

  // Onboarding / Auth
  String get onboardingTitle => this == AppLanguage.vi ? 'Chào mừng đến với MBooking!' : 'MBooking hello!';
  String get onboardingSubTitle => this == AppLanguage.vi ? 'Thưởng thức những bộ phim yêu thích của bạn' : 'Enjoy your favorite movies';
  String get signIn => this == AppLanguage.vi ? 'Đăng nhập' : 'Sign in';
  String get signUp => this == AppLanguage.vi ? 'Đăng ký' : 'Sign up';
  String get forgotPassword => this == AppLanguage.vi ? 'Quên mật khẩu?' : 'Forgot password?';
  String get dontHaveAccount => this == AppLanguage.vi ? 'Chưa có tài khoản? ' : "Don't have an account? ";
  String get alreadyHaveAccount => this == AppLanguage.vi ? 'Đã có tài khoản? ' : 'Already have an account? ';
  String get footerText => this == AppLanguage.vi 
      ? 'Bằng cách đăng nhập hoặc đăng ký, bạn đồng ý với Điều khoản dịch vụ và Chính sách bảo mật của chúng tôi' 
      : 'By sign in or sign up, you agree to our Terms of Service and Privacy Policy';
  
  // Recover Password
  String get forgotPasswordTitle => this == AppLanguage.vi ? 'Quên mật khẩu' : 'Forgot Password';
  String get recoverPasswordDesc => this == AppLanguage.vi 
      ? 'Nhập địa chỉ email của bạn và chúng tôi sẽ gửi cho bạn một liên kết để đặt lại mật khẩu.' 
      : 'Enter your email address and we will send you a link to reset your password.';
  String get sendLink => this == AppLanguage.vi ? 'Gửi liên kết' : 'Send Link';
  String get requestSent => this == AppLanguage.vi ? 'Đã gửi yêu cầu!' : 'Request Sent!';
  String get checkEmailDesc => this == AppLanguage.vi 
      ? 'Vui lòng kiểm tra hòm thư Email của bạn để thực hiện đổi mật khẩu mới.' 
      : 'Please check your email to reset your password.';

  // Registration Dialog
  String get registrationSuccess => this == AppLanguage.vi ? 'Đăng ký thành công!' : 'Registration successful!';
  String get registrationSuccessDesc => this == AppLanguage.vi 
      ? 'Tài khoản của bạn đã được tạo. Vui lòng đăng nhập để tiếp tục.' 
      : 'Your account has been created. Please log in to continue.';

  // Language Selection
  String get chooseLanguage => this == AppLanguage.vi ? 'Chọn ngôn ngữ' : 'Choose language';
  String get whichLanguage => this == AppLanguage.vi ? 'Bạn muốn sử dụng ngôn ngữ nào?' : 'Which language do you want to use?';
  String get useButtonText => this == AppLanguage.vi ? 'Sử dụng Tiếng Việt' : 'Use English';

  String get tmdbLanguage {
    switch (this) {
      case AppLanguage.en: return 'en-US';
      case AppLanguage.vi: return 'vi-VN';
    }
  }
}
