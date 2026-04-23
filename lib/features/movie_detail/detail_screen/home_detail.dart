import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Thêm Riverpod
import '../../../core/widgets/continue_button.dart';
import '../../../core/widgets/navigation_back.dart';
import '../../home/models/Api_service/movie_service.dart'; // Đảm bảo đúng đường dẫn provider
import '../../seat_selection/selection/seat_screen.dart';
import '../detail_widget/cinema_list.dart';
import '../detail_widget/movie_header.dart';
import '../detail_widget/movie_metainfo.dart';
import '../detail_widget/people_list.dart';
import '../detail_widget/section_title.dart';
import '../detail_widget/story_linetext.dart';
import '../provider/cinema_selection_provider.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  final int movieId; // Dùng ID để fetch chi tiết cho chuẩn
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  bool _isStoryExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Lắng nghe dữ liệu chi tiết phim từ Provider
    final movieAsync = ref.watch(movieDetailProvider(widget.movieId));
    final selectedCinema = ref.watch(selectedCinemaProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: movieAsync.when(
        data: (movie) => Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MovieHeader đã chứa logic Trailer bên trong
                  MovieHeader(movies: movie),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Truyền movie vào MetaInfo (Genre, Language, Censorship)
                        MovieMetaInfo(movie: movie),

                        const SizedBox(height: 20),
                        const SectionTitle(title: 'Storyline'),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isStoryExpanded = !_isStoryExpanded;
                            });
                          },
                          child: StorylineText(
                            movie: movie,
                            isExpanded: _isStoryExpanded,
                          ),
                        ),

                        const SizedBox(height: 20),
                        const SectionTitle(title: 'Director'),
                        const PeopleList(),

                        const SizedBox(height: 20),
                        const SectionTitle(title: 'Actor'),
                        const PeopleList(),

                        const SizedBox(height: 20),
                        const SectionTitle(title: 'Cinema'),
                        const CinemaList(),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Nút Continue cố định phía dưới
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: ContinueButton(
                onTap: () {
                  if (selectedCinema == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng chọn rạp chiếu trước khi tiếp tục'),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SeatSelectionScreen(),
                      ),
                    );
                  }
                },
              ),
            ),

            // Nút Back
            const Positioned(top: 40, left: 16, child: NavigationBack()),
          ],
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.amber)),
        error: (err, stack) => Center(
          child: Text('Lỗi: $err', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
