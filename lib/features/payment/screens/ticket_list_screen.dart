import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../authentication/repository/auth_repository.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../home/models/Api_service/movie_service.dart';
import '../../home/screens/home_screen.dart';
import '../../home/screens/see_all_movies_screen.dart';
import '../models/booking_model.dart';
import '../repository/booking_repository.dart';
import 'my_ticket_screen.dart';

class TicketListScreen extends ConsumerWidget {
  const TicketListScreen({super.key});

  void _onItemTapped(BuildContext context, int index) {
    if (index == 1) return;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SeeAllMoviesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text("Vui lòng đăng nhập để xem vé", style: TextStyle(color: Colors.white))),
      );
    }
    
    final bookingsAsync = ref.watch(userBookingsProvider(user.uid));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My ticket',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.confirmation_num_outlined, color: Colors.grey, size: 64),
                  SizedBox(height: 16),
                  Text(
                    "Bạn chưa có vé nào",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              return _TicketCard(booking: bookings[index]);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.hexFCC434),
        ),
        error: (err, stack) {
          // Hiển thị thông báo nếu thiếu Index
          if (err.toString().contains('failed-precondition')) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Vui lòng nhấn vào link trong Console để tạo Index cho Ticket List",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            );
          }
          return Center(
            child: Text("Lỗi: $err", style: const TextStyle(color: Colors.red)),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1,
        onItemTapped: (index) => _onItemTapped(context, index),
      ),
    );
  }
}

class _TicketCard extends ConsumerWidget {
  final BookingModel booking;
  const _TicketCard({required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        // Hiện loading trong khi tải lại thông tin phim đầy đủ từ API
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: AppColors.hexFCC434),
          ),
        );

        try {
          // Fetch MovieModel đầy đủ vì màn MyTicketScreen cần (duration, genres...)
          final movie = await ref.read(movieServiceProvider).fetchMovieDetail(booking.movieId);
          if (context.mounted) {
            Navigator.pop(context); // Tắt loading
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyTicketScreen(
                  booking: booking,
                  movie: movie,
                ),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Không thể tải thông tin phim: $e")),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.hex1C1C1C,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Poster phim
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                'https://image.tmdb.org/t/p/w200${booking.moviePoster}',
                width: 100,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  color: Colors.grey[900],
                  child: const Icon(Icons.movie, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Thông tin vé
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      booking.movieTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.grey, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          '${booking.bookingTime} • ${booking.bookingDate}',
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.grey, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            booking.cinemaName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
