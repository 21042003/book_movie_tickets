import 'package:book_movie_tickets/features/home/screens/see_all_movies_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/see_all_click.dart';
import '../controllers/see_all_movies_controller.dart';
import '../models/movie_model.dart';
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

  List<MovieModel> popularMovies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.hex000000,
      body: SafeArea(
        child: ListView(
          children: [
            HomeHeader(
              userName: "Hai",
              location: "HaNoi, VietNam",
              onAvatarTap: () {
                print("home");
              },
              onNotificationTap: () {},
            ),
            SearchBarWidget(
              controller: _controller,
              onChanged: (value) {
                print(value);
              },
            ),
            const SizedBox(height: 24.0),
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
            const SizedBox(height: 24.0),
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
            const SizedBox(height: 24.0),
            ComingSoonList(),
            const SizedBox(height: 24.0),
            SeeAllClick(title: "Promo & Discount", onTap: () {}),
          ],
        ),
      ),
    );
  }
}
