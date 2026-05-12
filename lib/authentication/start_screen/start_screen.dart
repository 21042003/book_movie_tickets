import 'package:book_movie_tickets/authentication/start_screen/widgets/auth_action_buttons.dart';
import 'package:book_movie_tickets/authentication/start_screen/widgets/auth_footer.dart';
import 'package:book_movie_tickets/authentication/start_screen/widgets/auth_header.dart';
import 'package:book_movie_tickets/authentication/start_screen/widgets/onboarding_content.dart';
import 'package:flutter/material.dart';

import '../login_screen/login_screen.dart';
import '../register_screen/register_screen.dart';


class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              onSignUp: () {
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
