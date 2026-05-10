import 'package:book_movie_tickets/features/home/screens/see_all_movies_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../core/widgets/see_all_click.dart';
import '../../payment/screens/ticket_list_screen.dart';
import '../controllers/see_all_movies_controller.dart';
import '../widgets/coming_soon_section.dart';
import '../widgets/home_header.dart';
import '../widgets/movie_card.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.hex000000,
      body: SafeArea(
        child: ListView(
          children: [
            HomeHeader(
              userName: "Angelina",
              location: "HaNoi, VietNam",
              onAvatarTap: () {},
              onNotificationTap: () {},
            ),
            SearchBarWidget(
              controller: _controller,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16.0),
            SeeAllClick(
              title: "Now playing",
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
              title: "Coming soon",
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
            SeeAllClick(title: "Promo & Discount", onTap: () {}),
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
