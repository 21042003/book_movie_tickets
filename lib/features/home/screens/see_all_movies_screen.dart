import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../payment/screens/ticket_list_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../controllers/see_all_movies_controller.dart';
import '../models/movie_model.dart';
import '../../movie_detail/detail_screen/home_detail.dart';
import 'home_screen.dart';

class SeeAllMoviesScreen extends ConsumerStatefulWidget {
  final MovieCategoryType initialCategory;
  const SeeAllMoviesScreen({super.key, this.initialCategory = MovieCategoryType.nowPlaying});

  @override
  ConsumerState<SeeAllMoviesScreen> createState() => _SeeAllMoviesScreenState();
}

class _SeeAllMoviesScreenState extends ConsumerState<SeeAllMoviesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedCategoryProvider.notifier).state = widget.initialCategory;
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(movieListNotifierProvider.notifier).fetchMovies();
    }
  }

  void _onItemTapped(int index) {
    if (index == 2) return;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TicketListScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(movieListNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const _CustomTabBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: RefreshIndicator(
          onRefresh: () => ref.read(movieListNotifierProvider.notifier).fetchMovies(isRefresh: true),
          color: AppColors.hexFCC434,
          child: _buildBody(state),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 2,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildBody(MovieListState state) {
    if (state.isLoading && state.movies.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.hexFCC434),
      );
    }

    if (state.error != null && state.movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Lỗi: ${state.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(movieListNotifierProvider.notifier).fetchMovies(isRefresh: true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.hexFCC434),
              child: const Text('Thử lại', style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        childAspectRatio: 0.58,
      ),
      itemCount: state.movies.length + (state.isLoadingMore ? 2 : 0),
      itemBuilder: (context, index) {
        if (index < state.movies.length) {
          return _MovieGridItem(movie: state.movies[index]);
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: AppColors.hexFCC434, strokeWidth: 2),
            ),
          );
        }
      },
    );
  }
}

class _CustomTabBar extends ConsumerWidget {
  const _CustomTabBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.hex1C1C1C,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _TabItem(
            title: 'Now playing',
            isSelected: selectedCategory == MovieCategoryType.nowPlaying,
            onTap: () => ref.read(selectedCategoryProvider.notifier).state =
                MovieCategoryType.nowPlaying,
          ),
          _TabItem(
            title: 'Coming soon',
            isSelected: selectedCategory == MovieCategoryType.comingSoon,
            onTap: () => ref.read(selectedCategoryProvider.notifier).state =
                MovieCategoryType.comingSoon,
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.hexFCC434 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _MovieGridItem extends ConsumerWidget {
  final MovieModel movie;
  const _MovieGridItem({required this.movie});

  String _formatRuntime(int minutes) {
    if (minutes <= 0) return '';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours > 0) {
      return '$hours h $remainingMinutes m';
    } else {
      return '$remainingMinutes m';
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'TBA';
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final isComingSoon = selectedCategory == MovieCategoryType.comingSoon;
    final tr = ref.watch(translationsProvider);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movieId: movie.id),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[900],
                    alignment: Alignment.center,
                    child: Text(
                      tr.loading,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[900],
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.broken_image, color: Colors.white, size: 24),
                      const SizedBox(height: 4),
                      Text(
                        tr.loading, // Hiển thị "Đang tải" khi lỗi theo yêu cầu của bạn
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.hexFCC434,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (!isComingSoon) ...[
                const Icon(Icons.star, color: AppColors.hexFCC434, size: 12),
                const SizedBox(width: 4),
                Text(
                  '${movie.voteAverage}',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
                const SizedBox(width: 8),
                if (movie.runtime > 0) ...[
                  const Icon(Icons.access_time, color: Colors.grey, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    _formatRuntime(movie.runtime),
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ] else ...[
                const Icon(Icons.calendar_month_outlined, color: Colors.grey, size: 12),
                const SizedBox(width: 4),
                Text(
                  _formatDate(movie.releaseDate),
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.videocam_outlined, color: Colors.grey, size: 12),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  movie.genres.isNotEmpty ? movie.genres[0].name : 'Movie',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
