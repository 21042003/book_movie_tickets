import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import '../../movie_detail/detail_screen/home_detail.dart';
import '../controllers/search_controller.dart';
import '../models/movie_model.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);
    final searchResults = ref.watch(searchMoviesProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: tr.search,
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                ref.read(searchQueryProvider.notifier).state = '';
              },
            ),
        ],
      ),
      body: searchResults.when(
        data: (movies) {
          if (movies.isEmpty) {
            return Center(
              child: Text(
                _searchController.text.isEmpty ? '' : 'Không tìm thấy phim',
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
              childAspectRatio: 0.52,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) => _SearchItem(movie: movies[index]),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.hexFCC434),
        ),
        error: (err, stack) => Center(
          child: Text('Lỗi: $err', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}

class _SearchItem extends StatelessWidget {
  final MovieModel movie;
  const _SearchItem({required this.movie});

  @override
  Widget build(BuildContext context) {
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
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey[900]),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.hexFCC434,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 20,
            child: Row(
              children: [
                const Icon(Icons.star, color: AppColors.hexFCC434, size: 14),
                const SizedBox(width: 4),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    movie.genres.isNotEmpty ? movie.genres[0].name : '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
