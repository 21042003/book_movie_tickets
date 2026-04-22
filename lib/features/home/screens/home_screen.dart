import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/see_all_click.dart';
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
            SeeAllClick(title: "Now playing", onTap: () {}),
            const SizedBox(height: 24.0),
            MovieCard(),
            // Trong ListView ở Home
            const SizedBox(height: 24.0),
            SeeAllClick(title: "Coming soon", onTap: () {}),
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
