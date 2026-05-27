import 'package:flutter/material.dart';

class OrderInfoSection extends StatelessWidget {
  final String orderId;
  final String selectedSeats;

  const OrderInfoSection({
    super.key,
    required this.orderId,
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInfoRow('Oder ID', orderId),
        const SizedBox(height: 12),
        _buildInfoRow('Seat', selectedSeats),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
