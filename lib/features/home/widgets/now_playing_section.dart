import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/movie_model.dart';

class NowPlayingSection extends StatelessWidget {
  final MovieModel movies;

  const NowPlayingSection({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 310,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500${movies.posterPath}",
                  fit: BoxFit.cover,
                  width: 310.0,
                  height: 440.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                movies.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.hexFCC434,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "2h29m • Action, adventure, sci-fi",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
