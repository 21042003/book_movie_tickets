import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../movie_detail/detail_screen/home_detail.dart';
import '../models/Api_service/movie_service.dart';
import 'now_playing_section.dart';

class MovieCard extends ConsumerWidget {
  const MovieCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

        return SizedBox(
          height: 550,
          child: PageView.builder(
            itemCount: movies.length,
            // Trong file movie_card.dart
            itemBuilder: (context, index) {
              final currentMovie =
                  movies[index]; // movies lấy từ popularMoviesProvider
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Truyền ID sang để màn Detail tự fetch bản Full
                      builder: (context) =>
                          MovieDetailScreen(movieId: currentMovie.id),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: NowPlayingSection(movies: currentMovie),
                ),
              );
            },
          ),
        );
      },
      // B. Trạng thái khi đang tải (Loading)
      loading: () => const SizedBox(
        height: 550,
        child: Center(child: CircularProgressIndicator(color: Colors.amber)),
      ),
      // C. Trạng thái khi gặp lỗi (Error)
      error: (err, stack) => SizedBox(
        height: 550,
        child: Center(
          child: Text('Lỗi: $err', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
