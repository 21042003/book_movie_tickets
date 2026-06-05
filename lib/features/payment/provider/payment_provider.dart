import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentState {
  final String? voucherCode;
  final double discountAmount;
  final String? error;

  PaymentState({
    this.voucherCode,
    this.discountAmount = 0.0,
    this.error,
  });

  PaymentState copyWith({
    String? voucherCode,
    double? discountAmount,
    String? error,
  }) {
    return PaymentState(
      voucherCode: voucherCode ?? this.voucherCode,
      discountAmount: discountAmount ?? this.discountAmount,
      error: error,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier() : super(PaymentState());

  void applyVoucher(String code, double currentTotal) {
    // Mock voucher logic
    final upperCode = code.toUpperCase();
    if (upperCode == 'GIAMGIA10') {
      state = state.copyWith(
        voucherCode: upperCode,
        discountAmount: currentTotal * 0.1,
        error: null,
      );
    } else if (upperCode == 'GIAMGIA50') {
      state = state.copyWith(
        voucherCode: upperCode,
        discountAmount: 50000.0, // Giảm thẳng 50k
        error: null,
      );
    } else if (upperCode == 'NEWBIE') {
       state = state.copyWith(
        voucherCode: upperCode,
        discountAmount: currentTotal * 0.2, // Giảm 20%
        error: null,
      );
    } else {
      state = state.copyWith(
        error: 'Mã giảm giá không hợp lệ',
        discountAmount: 0.0,
        voucherCode: null,
      );
    }
  }

  void clearVoucher() {
    state = PaymentState();
  }
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier();
});
