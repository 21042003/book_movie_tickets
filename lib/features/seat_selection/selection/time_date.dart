import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../movie_detail/provider/showtime_selection_provider.dart';

class TimeDateSelection extends ConsumerWidget {
  final int movieId;
  const TimeDateSelection({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final showtimesAsync = ref.watch(showtimesListProvider(movieId));
    final selectedShowtimeId = ref.watch(selectedShowtimeIdProvider);
    final now = DateTime.now();

    // Tự động chọn suất chiếu đầu tiên khi danh sách tải xong
    ref.listen(showtimesListProvider(movieId), (previous, next) {
      next.whenData((showtimes) {
        if (showtimes.isNotEmpty && ref.read(selectedShowtimeIdProvider) == null) {
          ref.read(selectedShowtimeIdProvider.notifier).state = showtimes.first.id;
        }
      });
    });

    return Column(
      children: [
        // 1. Chọn Ngày
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = now.add(Duration(days: index));
              final isSelected = DateUtils.isSameDay(date, selectedDate);

              return GestureDetector(
                onTap: () {
                  ref.read(selectedDateProvider.notifier).state = date;
                  ref.read(selectedShowtimeIdProvider.notifier).state = null; // Reset để chọn suất mới
                },
                child: Container(
                  width: 55,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.hexFCC434 : AppColors.hex1C1C1C,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(date),
                        style: TextStyle(
                          color: isSelected ? Colors.black : AppColors.hex8C8C8C,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // 2. Chọn Giờ (Suất chiếu)
        SizedBox(
          height: 40,
          child: showtimesAsync.when(
            data: (showtimes) {
              if (showtimes.isEmpty) {
                return const Center(child: Text("Hết suất chiếu trong ngày", style: TextStyle(color: Colors.grey, fontSize: 12)));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: showtimes.length,
                itemBuilder: (context, index) {
                  final st = showtimes[index];
                  final isSelected = selectedShowtimeId == st.id;
                  final time = DateFormat('HH:mm').format(st.startTime);

                  return GestureDetector(
                    onTap: () => ref.read(selectedShowtimeIdProvider.notifier).state = st.id,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.hexFCC434 : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? AppColors.hexFCC434 : AppColors.hex3B3B3B),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (e, s) {
              // Hiển thị hướng dẫn tạo Index nếu gặp lỗi failed-precondition
              if (e.toString().contains('failed-precondition')) {
                return const Center(child: Text("Vui lòng nhấn link ở Console để tạo Index", style: TextStyle(color: Colors.orange, fontSize: 10)));
              }
              return const Center(child: Text("Lỗi tải suất chiếu", style: TextStyle(color: Colors.red)));
            },
          ),
        ),
      ],
    );
  }
}
