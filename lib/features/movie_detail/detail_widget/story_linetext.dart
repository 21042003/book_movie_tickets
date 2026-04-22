import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/models/movie_model.dart';

class StorylineText extends StatelessWidget {
  final MovieModel movie;
  final bool isExpanded; // Thêm biến trạng thái

  const StorylineText({
    super.key,
    required this.movie,
    required this.isExpanded
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.overview.isNotEmpty ? movie.overview : "Nội dung phim đang được cập nhật...",
          // Nếu đang mở rộng thì không giới hạn dòng, nếu thu gọn thì để 3 dòng
          maxLines: isExpanded ? null : 3,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.hexF2F2F2,
            fontSize: 16,
            fontWeight: FontWeight.w300,
            height: 1.5,
          ),
        ),
        // Chỉ hiện "See more" khi văn bản đang bị thu gọn
        if (!isExpanded && movie.overview.length > 150)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'See more',
              style: TextStyle(
                color: AppColors.hexFCC434,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }
}