import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../controllers/see_all_movies_controller.dart';
import '../models/movie_model.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 2);

class SeeAllMoviesScreen extends ConsumerStatefulWidget {
  final MovieCategoryType initialCategory;
  const SeeAllMoviesScreen({super.key, this.initialCategory = MovieCategoryType.nowPlaying});

  @override
  ConsumerState<SeeAllMoviesScreen> createState() => _SeeAllMoviesScreenState();
}

class _SeeAllMoviesScreenState extends ConsumerState<SeeAllMoviesScreen> {
  @override
  void initState() {
    super.initState();
    // Đặt category ban đầu dựa trên tham số truyền vào
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedCategoryProvider.notifier).state = widget.initialCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieAsync = ref.watch(movieListProvider);
    final navIndex = ref.watch(bottomNavIndexProvider);

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
        child: movieAsync.when(
          data: (movies) => _MovieGrid(movies: movies),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.hexFCC434),
          ),
          error: (err, stack) {
            debugPrint('Error loading movies: $err');
            debugPrint(stack.toString());
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Lỗi tải phim: $err',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: () => ref.refresh(movieListProvider),
                    child: const Text('Thử lại'),
                  )
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: navIndex,
        onItemTapped: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;
        },
      ),
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

class _MovieGrid extends StatelessWidget {
  final List<MovieModel> movies;
  const _MovieGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        childAspectRatio: 0.55,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return _MovieGridItem(movie: movies[index]);
      },
    );
  }
}

class _MovieGridItem extends StatelessWidget {
  final MovieModel movie;
  const _MovieGridItem({required this.movie});

  String _formatRuntime(int minutes) {
    if (minutes <= 0) return 'N/A';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours > 0) {
      return '$hours hour $remainingMinutes minutes';
    } else {
      return '$remainingMinutes minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.grey[900]),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          movie.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.hexFCC434,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: AppColors.hexFCC434, size: 14),
            const SizedBox(width: 4),
            Text(
              '${movie.voteAverage} (${movie.voteCount})',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.access_time, color: Colors.grey, size: 14),
            const SizedBox(width: 4),
            Text(
              _formatRuntime(movie.runtime),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.videocam_outlined, color: Colors.grey, size: 14),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                movie.genres.map((g) => g.name).join(', '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
