import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/models/movie_model.dart';

class PaymentMovieInfo extends StatelessWidget {
  final MovieModel movie;
  final String selectedCinema;
  final DateTime selectedDate;
  final String selectedTime;

  const PaymentMovieInfo({
    super.key,
    required this.movie,
    required this.selectedCinema,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.hex1C1C1C,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://image.tmdb.org/t/p/w200${movie.posterPath}',
              width: 100,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: AppColors.hexFCC434,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoItem(Icons.videocam_outlined, movie.genres.map((e) => e.name).join(', ')),
                const SizedBox(height: 4),
                _buildInfoItem(Icons.location_on_outlined, selectedCinema),
                const SizedBox(height: 4),
                _buildInfoItem(
                  Icons.access_time,
                  '${DateFormat('dd.MM.yyyy').format(selectedDate)} • $selectedTime',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 16),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
