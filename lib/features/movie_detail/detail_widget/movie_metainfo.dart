import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/models/movie_model.dart';

class MovieMetaInfo extends StatelessWidget {
  final MovieModel movie;

  const MovieMetaInfo({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final String genresText = movie.genres.isNotEmpty
        ? movie.genres.map((e) => e.name).join(', ')
        : 'Đang cập nhật';
    return Column(
      children: [
        InfoRow(label: 'Movie genre:', value: genresText),
        InfoRow(label: 'Censorship:', value: movie.adult ? '18+' : '13+'),
        InfoRow(
          label: 'Language:',
          value: movie.originalLanguage.toUpperCase(),
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.hexCDCDCD,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.hexF2F2F2,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

