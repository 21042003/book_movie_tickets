import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import '../provider/seat_selection_provider.dart';
import 'seat_text.dart';
import 'seat_order.dart';

class SeatSelectionScreen extends ConsumerWidget {
  final int movieId;
  final String showtimeId;
  const SeatSelectionScreen({super.key, required this.movieId, required this.showtimeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Lắng nghe thay đổi ghế Real-time
    ref.listen(firestoreShowtimeProvider(showtimeId), (previous, next) {
      next.whenData((seatMap) {
        ref.read(seatSelectionProvider.notifier).updateFromFirestore(seatMap);
      });
    });

    // 2. Lấy thông tin suất chiếu để hiển thị Header
    final showtimeAsync = ref.watch(firestoreShowtimeFullProvider(showtimeId));
    final state = ref.watch(seatSelectionProvider);
    final tr = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 16, right: 16),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
                Expanded(child: Center(child: Text(tr.selectSeat, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)))),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // Screen Arc
          Container(
            height: 60,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.hexFCC434.withOpacity(0.4), Colors.transparent]),
            ),
            child: CustomPaint(painter: ScreenPainter()),
          ),

          // Seat Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 12, childAspectRatio: 1, crossAxisSpacing: 4, mainAxisSpacing: 4),
                itemCount: state.seats.length,
                itemBuilder: (context, index) {
                  final seat = state.seats[index];
                  return SeatWidget(seat: seat, onTap: () => ref.read(seatSelectionProvider.notifier).toggleSeat(seat.label));
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
                _buildLegendItem(tr.available, AppColors.hex1C1C1C),
                _buildLegendItem(tr.reserved, AppColors.hex261D08),
                _buildLegendItem(tr.selected, AppColors.hexFCC434),
              ],
            ),
          ),

          // Showtime Info Summary
          showtimeAsync.when(
            data: (st) => Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: AppColors.hex1C1C1C, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem(Icons.calendar_month, DateFormat('dd MMM').format(st.startTime)),
                  _buildInfoItem(Icons.access_time, DateFormat('HH:mm').format(st.startTime)),
                  _buildInfoItem(Icons.room, st.cinemaName),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (e, s) => const SizedBox.shrink(),
          ),
          
          const SizedBox(height: 20),
          SeatOrderBottomBar(movieId: movieId, showtimeId: showtimeId),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(children: [
      Container(width: 16, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(color: AppColors.hex8C8C8C, fontSize: 12)),
    ]);
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(children: [
      Icon(icon, color: AppColors.hexFCC434, size: 16),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
    ]);
  }
}

class ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.hexFCC434..style = PaintingStyle.stroke..strokeWidth = 2;
    final path = Path();
    path.moveTo(size.width * 0.1, 10);
    path.quadraticBezierTo(size.width / 2, 0, size.width * 0.9, 10);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
