import 'package:book_movie_tickets/features/home/screens/see_all_movies_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../authentication/repository/auth_repository.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../core/widgets/see_all_click.dart';
import '../../../core/localization/language_provider.dart';
import '../../payment/screens/ticket_list_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../controllers/see_all_movies_controller.dart';
import '../widgets/coming_soon_section.dart';
import '../widgets/home_header.dart';
import '../widgets/movie_card.dart';
import '../widgets/search_bar_widget.dart';
import 'search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  void _onItemTapped(int index) {
    if (index == 0) return;
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TicketListScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SeeAllMoviesScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          children: [
            HomeHeader(
              userName: ref.watch(authRepositoryProvider).currentUser?.displayName ?? "User",
              location: "HaNoi, VietNam",
              onAvatarTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              onNotificationTap: () {},
            ),
            SearchBarWidget(
              controller: _controller,
              readOnly: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              onChanged: (value) {},
            ),
            const SizedBox(height: 16.0),
            SeeAllClick(
              title: tr.nowPlaying,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SeeAllMoviesScreen(
                      initialCategory: MovieCategoryType.nowPlaying,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            const MovieCard(),
            const SizedBox(height: 24.0),
            SeeAllClick(
              title: tr.comingSoon,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SeeAllMoviesScreen(
                      initialCategory: MovieCategoryType.comingSoon,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            const ComingSoonList(),
            const SizedBox(height: 24.0),
            SeeAllClick(title: tr.promoDiscount, onTap: () {}),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
