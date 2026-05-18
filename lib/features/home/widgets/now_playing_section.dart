import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/movie_model.dart';

class NowPlayingSection extends StatelessWidget {
  final MovieModel movies;

  const NowPlayingSection({super.key, required this.movies});

  String _formatRuntime(int minutes) {
    if (minutes <= 0) return '';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${remainingMinutes}m • ';
    } else {
      return '${remainingMinutes}m • ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: Image.network(
              "https://image.tmdb.org/t/p/w500${movies.posterPath}",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          movies.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          "${_formatRuntime(movies.runtime)}${movies.genres.map((g) => g.name).join(', ')}",
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.hex8C8C8C,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: AppColors.hexFCC434, size: 18),
            const SizedBox(width: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: movies.voteAverage.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppColors.hexFCC434,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' (${movies.voteCount})',
                    style: const TextStyle(
                      color: AppColors.hex8C8C8C,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
