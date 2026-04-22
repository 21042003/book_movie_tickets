import 'package:flutter/material.dart';


import '../../../core/constants/app_colors.dart';
import '../models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final VoidCallback onTap;
  final MovieModel movies;

  const MovieCard({super.key, required this.movies, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.translucent,
          child: Wrap(
            spacing: 16,
            children: [
              Container(
                width: 310,
                // height: 440,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        "https://image.tmdb.org/t/p/w500${movies.posterPath}",
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(height: 10),
                    Text(
                      movies.title,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.hexF2F2F2,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: AppColors.hexFCC434),
                        SizedBox(width: 4),
                        Text(
                          "${movies.voteAverage}",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.hexF2F2F2,
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
      ],
    );
  }
}
