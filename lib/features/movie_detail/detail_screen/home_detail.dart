import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/continue_button.dart';
import '../../../core/widgets/navigation_back.dart';
import '../../home/models/Api_service/movie_service.dart';
import '../../seat_selection/selection/seat_screen.dart';
import '../detail_widget/cinema_list.dart';
import '../detail_widget/movie_header.dart';
import '../detail_widget/movie_metainfo.dart';
import '../detail_widget/section_title.dart';
import '../detail_widget/story_linetext.dart';
import '../provider/cinema_selection_provider.dart';
import '../provider/showtime_selection_provider.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  bool _isStoryExpanded = false;

  @override
  Widget build(BuildContext context) {
    final movieAsync = ref.watch(movieDetailProvider(widget.movieId));
    final selectedCinemaId = ref.watch(selectedCinemaProvider);
    final selectedShowtimeId = ref.watch(selectedShowtimeIdProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: movieAsync.when(
        data: (movie) => Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MovieHeader(movies: movie),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MovieMetaInfo(movie: movie),
                        const SizedBox(height: 20),
                        const SectionTitle(title: 'Storyline'),
                        GestureDetector(
                          onTap: () => setState(() => _isStoryExpanded = !_isStoryExpanded),
                          child: StorylineText(movie: movie, isExpanded: _isStoryExpanded),
                        ),
                        const SizedBox(height: 20),
                        const SectionTitle(title: 'Cinema'),
                        const CinemaList(),
                        
                        if (selectedCinemaId != null) ...[
                          const SizedBox(height: 20),
                          const SectionTitle(title: 'Select Date'),
                          _buildDateSelection(),
                          const SizedBox(height: 20),
                          const SectionTitle(title: 'Select Showtime'),
                          _buildShowtimeList(movie.id),
                        ],
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: ContinueButton(
                onTap: () {
                  if (selectedCinemaId == null || selectedShowtimeId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn rạp và suất chiếu')),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeatSelectionScreen(
                          movieId: movie.id,
                          showtimeId: selectedShowtimeId,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            const Positioned(top: 40, left: 16, child: NavigationBack()),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
        error: (err, stack) => Center(child: Text('Lỗi: $err', style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildDateSelection() {
    final selectedDate = ref.watch(selectedDateProvider);
    final now = DateTime.now();
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = now.add(Duration(days: index));
          final isSelected = DateUtils.isSameDay(date, selectedDate);
          return GestureDetector(
            onTap: () {
              ref.read(selectedDateProvider.notifier).state = date;
              ref.read(selectedShowtimeIdProvider.notifier).state = null;
            },
            child: Container(
              width: 55,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFCC434) : const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('E').format(date), style: TextStyle(color: isSelected ? Colors.black : Colors.grey, fontSize: 10)),
                  Text(date.day.toString(), style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShowtimeList(int movieId) {
    final showtimesAsync = ref.watch(showtimesListProvider(movieId));
    final selectedId = ref.watch(selectedShowtimeIdProvider);

    return showtimesAsync.when(
      data: (showtimes) {
        if (showtimes.isEmpty) return const Text("Hết suất chiếu", style: TextStyle(color: Colors.grey));
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: showtimes.map((st) {
            final isSelected = selectedId == st.id;
            return GestureDetector(
              onTap: () => ref.read(selectedShowtimeIdProvider.notifier).state = st.id,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFCC434) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? const Color(0xFFFCC434) : const Color(0xFF3B3B3B)),
                ),
                child: Text(DateFormat('HH:mm').format(st.startTime), style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, s) {
        // IN LỖI RA CONSOLE ĐỂ KIỂM TRA
        debugPrint("❌ LỖI SHOWTIME: $e");
        debugPrint("❌ STACKTRACE: $s");
        return Text("Lỗi: $e", style: const TextStyle(color: Colors.red, fontSize: 10));
      },
    );
  }
}
