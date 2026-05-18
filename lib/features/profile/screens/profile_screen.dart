import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../authentication/start_screen/start_screen.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../core/localization/language_provider.dart';
import '../../home/screens/home_screen.dart';
import '../../home/screens/see_all_movies_screen.dart';
import '../../payment/screens/ticket_list_screen.dart';
import '../../../authentication/start_screen/widgets/language_bottom_sheet.dart';
import '../../../core/theme/theme_provider.dart';
import '../view_model/profile_view_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_switch_item.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _onItemTapped(BuildContext context, int index) {
    if (index == 3) return;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final profileNotifier = ref.read(profileViewModelProvider.notifier);
    final tr = ref.watch(translationsProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileHeader(user: profileState.user),
                    const SizedBox(height: 20),
                    ProfileMenuItem(
                      icon: Icons.work_outline,
                      title: tr.myTicket,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TicketListScreen()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.shopping_cart_outlined,
                      title: tr.paymentHistory,
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.translate,
                      title: tr.changeLanguage,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const LanguageBottomSheet(),
                        );
                      },
                    ),
                    ProfileSwitchItem(
                      icon: Icons.dark_mode_outlined,
                      title: tr.darkMode,
                      value: themeMode == ThemeMode.dark,
                      onChanged: (isDark) {
                        ref.read(themeModeProvider.notifier).state = 
                            isDark ? ThemeMode.dark : ThemeMode.light;
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.lock_outline,
                      title: tr.changePassword,
                      onTap: () {},
                    ),
                    ProfileSwitchItem(
                      icon: Icons.face_retouching_natural,
                      title: tr.faceId,
                      value: profileState.isBiometricEnabled,
                      onChanged: profileNotifier.toggleBiometric,
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextButton(
                        onPressed: () async {
                          //ref.read(authViewModelProvider.notifier).signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const StartScreen()),
                              (route) => false,
                            );
                          }
                        },
                        child: Text(
                          tr.signOut,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 3,
        onItemTapped: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
