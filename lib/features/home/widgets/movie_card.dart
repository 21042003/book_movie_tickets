import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../movie_detail/detail_screen/home_detail.dart';
import '../models/Api_service/movie_service.dart';
import 'now_playing_section.dart';

class MovieCard extends ConsumerStatefulWidget {
  const MovieCard({super.key});

  @override
  ConsumerState<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends ConsumerState<MovieCard> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.75);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Lắng nghe dữ liệu từ Provider
    final movieAsync = ref.watch(popularMoviesProvider);

    // 2. Sử dụng .when để xử lý 3 trạng thái của dữ liệu
    return movieAsync.when(
      // A. Trạng thái khi đã có dữ liệu (Data)
      data: (movies) {
        if (movies.isEmpty) {
          return const Center(
            child: Text(
              "Không có phim nào",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        // Chỉ lấy tối đa 10 phim để hiển thị ở Now Playing carousel
        final displayMovies = movies.take(10).toList();

        return Column(
          children: [
            SizedBox(
              height: 520,
              child: PageView.builder(
                controller: _pageController,
                itemCount: displayMovies.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final currentMovie = displayMovies[index];
                  
                  // Hiệu ứng scale cho movie ở giữa
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.hasContentDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.1)).clamp(0.9, 1.0);
                      } else {
                        // Trạng thái ban đầu khi chưa scroll
                        value = index == 0 ? 1.0 : 0.9;
                      }
                      
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailScreen(movieId: currentMovie.id),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: NowPlayingSection(movies: currentMovie),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                displayMovies.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.hexFCC434
                        : AppColors.hex3B3B3B,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      // B. Trạng thái khi đang tải (Loading)
      loading: () => const SizedBox(
        height: 520,
        child: Center(child: CircularProgressIndicator(color: Colors.amber)),
      ),
      // C. Trạng thái khi gặp lỗi (Error)
      error: (err, stack) => SizedBox(
        height: 520,
        child: Center(
          child: Text('Lỗi: $err', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
