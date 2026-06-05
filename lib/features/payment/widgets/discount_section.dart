import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import '../provider/payment_provider.dart';

class DiscountSection extends ConsumerStatefulWidget {
  final double currentTotal;
  const DiscountSection({super.key, required this.currentTotal});

  @override
  ConsumerState<DiscountSection> createState() => _DiscountSectionState();
}

class _DiscountSectionState extends ConsumerState<DiscountSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);
    final paymentState = ref.watch(paymentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.hex1C1C1C,
                  borderRadius: BorderRadius.circular(12),
                  border: paymentState.error != null 
                    ? Border.all(color: Colors.red, width: 1)
                    : (paymentState.voucherCode != null 
                        ? Border.all(color: AppColors.hexFCC434, width: 1) 
                        : null),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.confirmation_num_outlined, 
                      color: paymentState.voucherCode != null ? AppColors.hexFCC434 : Colors.grey
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: tr.discountCode,
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_controller.text.isNotEmpty || paymentState.voucherCode != null)
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                        onPressed: () {
                          _controller.clear();
                          ref.read(paymentProvider.notifier).clearVoucher();
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  ref.read(paymentProvider.notifier).applyVoucher(
                    _controller.text, 
                    widget.currentTotal
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.hexFCC434,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(100, 50),
              ),
              child: Text(tr.apply, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        if (paymentState.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              paymentState.error!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        if (paymentState.voucherCode != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              'Đã áp dụng mã: ${paymentState.voucherCode}',
              style: const TextStyle(color: AppColors.hexFCC434, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

