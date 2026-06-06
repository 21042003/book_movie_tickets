import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/repository/auth_repository.dart';
import '../../authentication/start_screen/start_screen.dart';
import '../../authentication/login_screen/login_screen.dart';
import '../../authentication/register_screen/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/payment/screens/my_ticket_screen.dart';
import '../../features/payment/screens/ticket_list_screen.dart';

// Helper class to convert Stream to Listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}


final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(ref.watch(authRepositoryProvider).authStateChanges),
    redirect: (context, state) {
      final user = authState.value;
      final isLoggingIn = state.matchedLocation == '/start' || 
                          state.matchedLocation == '/login' || 
                          state.matchedLocation == '/register';

      if (user == null) {
        // Nếu chưa đăng nhập và không ở trang login/start thì về start
        return isLoggingIn ? null : '/start';
      }

      // Nếu đã đăng nhập mà vẫn ở trang login/start thì vào home
      if (isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/start',
        builder: (context, state) => const StartScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/my-tickets',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return MyTicketScreen(
            booking: extra['booking'],
            movie: extra['movie'],
          );
        },
      ),
      GoRoute(
        path: '/ticket-list',
        builder: (context, state) => const TicketListScreen(),
      ),
    ],
  );
});
