import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/models/Api_service/movie_service.dart';
import '../../home/models/movie_model.dart';

class MovieHeader extends ConsumerStatefulWidget {
  final MovieModel movies;
  const MovieHeader({super.key, required this.movies});

  @override
  ConsumerState<MovieHeader> createState() => _MovieHeaderState();
}

class _MovieHeaderState extends ConsumerState<MovieHeader> {
  YoutubePlayerController? _controller;
  bool _showTrailer = false; // Biến kiểm soát hiển thị video

  @override
  void dispose() {
    _controller?.dispose(); // Giải phóng bộ nhớ khi thoát
    super.dispose();
  }

  void _playTrailer(String key) {
    setState(() {
      _controller = YoutubePlayerController(
        initialVideoId: key,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
      );
      _showTrailer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // PHẦN HIỂN THỊ: Nếu _showTrailer = true và có controller thì hiện Video, ngược lại hiện Ảnh
        SizedBox(
          height: 450,
          width: double.infinity,
          child: (_showTrailer && _controller != null)
              ? YoutubePlayer(
            controller: _controller!,
            showVideoProgressIndicator: true,
            onEnded: (meta) {
              setState(() => _showTrailer = false); // Hết phim thì hiện lại ảnh
            },
          )
              : Image.network(
            "https://image.tmdb.org/t/p/w500${widget.movies.backdropPath}",
            fit: BoxFit.cover,
          ),
        ),

        // Gradient (Chỉ hiện khi không xem video để nhìn rõ chữ)
        if (!_showTrailer)
          Container(
            height: 450,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.8), Colors.black],
              ),
            ),
          ),

        // Card thông tin phim
        Positioned(
          bottom: 0,
          left: 16,
          right: 16,
          child: _showTrailer
              ? const SizedBox.shrink() // Ẩn card khi đang xem video cho thoáng
              : _buildInfoCard(),
        ),

        // Nút tắt video (Chỉ hiện khi đang xem trailer)
        if (_showTrailer)
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => setState(() => _showTrailer = false),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.hex1C1C1C.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.movies.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              Text(' ${widget.movies.voteAverage.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  // Lấy key từ provider
                  final trailerKey = await ref.read(movieTrailerProvider(widget.movies.id).future);
                  if (trailerKey != null) {
                    _playTrailer(trailerKey);
                  }
                },
                icon: const Icon(Icons.play_arrow, color: Colors.black),
                label: const Text('Watch trailer', style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.hexFCC434),
              ),
            ],
          ),
        ],
      ),
    );
  }
}