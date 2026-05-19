import 'package:book_movie_tickets/authentication/start_screen/widgets/auth_action_buttons.dart';
import 'package:book_movie_tickets/authentication/start_screen/widgets/auth_footer.dart';
import 'package:book_movie_tickets/authentication/start_screen/widgets/auth_header.dart';
import 'package:book_movie_tickets/authentication/start_screen/widgets/onboarding_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../login_screen/login_screen.dart';
import '../register_screen/register_screen.dart';
import '../view_model/auth_view_model.dart';


class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const AuthHeader(),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    OnboardingContent(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            AuthActionButtons(
              onSignIn: () {
                ref.read(authViewModelProvider.notifier).clearErrors();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              onSignUp: () {
                ref.read(authViewModelProvider.notifier).clearErrors();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
            ),
            const AuthFooter(),
          ],
        ),
      ),
    );
  }
}
