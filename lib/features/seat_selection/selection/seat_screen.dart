import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../provider/seat_selection_provider.dart';
import 'seat_text.dart';
import 'time_date.dart';
import 'seat_order.dart';

class SeatSelectionScreen extends ConsumerWidget {
  const SeatSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(seatSelectionProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Select seat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Balancing the back button
              ],
            ),
          ),

          // Screen Gradient Effect
          Container(
            height: 60,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.hexFCC434.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
            child: CustomPaint(
              painter: ScreenPainter(),
            ),
          ),

          const SizedBox(height: 20),

          // Seat Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 12,
                  childAspectRatio: 1,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: state.seats.length,
                itemBuilder: (context, index) {
                  final seat = state.seats[index];
                  return SeatWidget(
                    seat: seat,
                    onTap: () => ref
                        .read(seatSelectionProvider.notifier)
                        .toggleSeat(seat.label),
                  );
                },
              ),
            ),
          ),

          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem("Available", AppColors.hex1C1C1C),
                _buildLegendItem("Reserved", AppColors.hex261D08),
                _buildLegendItem("Selected", AppColors.hexFCC434),
              ],
            ),
          ),

          // Date & Time Selection
          const TimeDateSelection(),
          
          const SizedBox(height: 20),

          // Bottom Bar
          const SeatOrderBottomBar(),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: AppColors.hex8C8C8C, fontSize: 12),
        ),
      ],
    );
  }
}

class ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.hexFCC434
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(size.width * 0.1, 10);
    path.quadraticBezierTo(size.width / 2, 0, size.width * 0.9, 10);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
