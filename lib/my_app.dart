import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/theme_provider.dart';
import 'authentication/start_screen/start_screen.dart';
import 'authentication/repository/auth_repository.dart';
import 'features/home/screens/home_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'movie-ticket',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: authState.when(
        data: (user) {
          if (user != null) {
            return const HomeScreen();
          }
          return const StartScreen();
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => const StartScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
