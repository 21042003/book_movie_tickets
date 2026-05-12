import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_icons.dart';
import '../../seat_selection/repository/showtime_repository.dart';
import '../provider/cinema_selection_provider.dart';

final allCinemasProvider = FutureProvider((ref) async {
  return ref.watch(showtimeRepositoryProvider).getAllCinemas();
});

class CinemaList extends ConsumerWidget {
  const CinemaList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cinemasAsync = ref.watch(allCinemasProvider);
    final selectedCinemaId = ref.watch(selectedCinemaProvider);

    return cinemasAsync.when(
      data: (cinemas) {
        if (cinemas.isEmpty) {
          return const Center(
            child: Text("Không có rạp nào", style: TextStyle(color: Colors.white)),
          );
        }
        return Column(
          children: cinemas.map((cinema) {
            return _cinemaCard(
              ref,
              cinema['id'],
              cinema['name'] ?? 'Unknown',
              cinema['address'] ?? '',
              selectedCinemaId == cinema['id'],
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text("Lỗi: $err", style: const TextStyle(color: Colors.red)),
    );
  }

  Widget _cinemaCard(WidgetRef ref, String id, String name, String address, bool isSelected) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedCinemaProvider.notifier).state = id;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFCC434) : Colors.white10,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected 
              ? const Color(0xFFFCC434).withOpacity(0.1) 
              : Colors.white.withOpacity(0.05),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFFFCC434) : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(2),),
                        child: Image.asset(
                          fit: BoxFit.cover,
                          AppIcons.cgv,
                          width: 32,
                          height: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    address,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
