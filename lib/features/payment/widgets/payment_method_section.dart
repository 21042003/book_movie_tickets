import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_image.dart';

class PaymentMethodSection extends StatelessWidget {
  final String selectedMethod;
  final Function(String) onMethodSelected;

  const PaymentMethodSection({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildPaymentMethodItem('Zalo Pay', AppImage.zalopay),
        _buildPaymentMethodItem('MoMo', AppImage.momo),
        _buildPaymentMethodItem('Shopee Pay', AppImage.shopee),
        _buildPaymentMethodItem('ATM Card', AppImage.atm),
        _buildPaymentMethodItem(
          'International payments',
          AppImage.visa,
          subtitle: '(Visa, Master, JCB, Amex)',
        ),
      ],
    );
  }

  Widget _buildPaymentMethodItem(String name, String iconPath, {String? subtitle}) {
    bool isSelected = selectedMethod == name;
    return GestureDetector(
      onTap: () => onMethodSelected(name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.hex1C1C1C,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: AppColors.hexFCC434, width: 1) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  name.split(' ')[0],
                  style: const TextStyle(
                      color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 16)),
                  if (subtitle != null)
                    Text(subtitle,
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
