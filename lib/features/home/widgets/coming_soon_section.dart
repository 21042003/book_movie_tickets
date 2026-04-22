import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../movie_detail/detail_screen/home_detail.dart';
import '../models/Api_service/movie_service.dart';
import '../models/movie_model.dart';

class ComingSoonSection extends StatelessWidget {
  final MovieModel movies;
  final VoidCallback onTap;

  const ComingSoonSection({
    super.key,
    required this.movies,
    required this.onTap,
  });

  //clounder code

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,

      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500${movies.posterPath}",
                fit: BoxFit.cover,
                width: 160,
                height: 240.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movies.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.hexFCC434,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.video_camera_front_rounded,
                        color: AppColors.hexF2F2F2,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      // Thay thế đoạn Text fix cứng bằng đoạn này trong ComingSoonSection:
                      Expanded(
                        child: Text(
                          movies.genres.isNotEmpty
                              ? movies.genres.map((e) => e.name).join(', ')
                              : 'Khác',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.hexDEDEDE,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.hexF2F2F2,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          movies.releaseDate,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.hexF2F2F2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
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

class ComingSoonList extends ConsumerWidget {
  const ComingSoonList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Lắng nghe Provider phim sắp chiếu
    final upcomingAsync = ref.watch(upcomingMoviesProvider);

    // 2. Xử lý các trạng thái dữ liệu
    return upcomingAsync.when(
      data: (movies) {
        if (movies.isEmpty) {
          return const Center(
            child: Text(
              "Không có phim sắp chiếu",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return SizedBox(
          height: 350,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            // Trong file coming_soon_section.dart (ComingSoonList)
            itemBuilder: (context, index) {
              final currentMovie = movies[index]; // movies lấy từ upcomingMoviesProvider
              return ComingSoonSection(
                movies: currentMovie,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movieId: currentMovie.id),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 320,
        child: Center(child: CircularProgressIndicator(color: Colors.amber)),
      ),
      error: (err, stack) => SizedBox(
        height: 320,
        child: Center(
          child: Text("Lỗi: $err", style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
