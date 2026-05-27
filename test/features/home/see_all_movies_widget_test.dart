import 'package:book_movie_tickets/core/localization/language_provider.dart';
import 'package:book_movie_tickets/features/home/controllers/see_all_movies_controller.dart';
import 'package:book_movie_tickets/features/home/screens/see_all_movies_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SeeAllMoviesScreen Widget Tests', () {
    testWidgets('Hiển thị Loading Indicator khi đang tải dữ liệu', (WidgetTester tester) async {
      final initialState = MovieListState.initial().copyWith(isLoading: true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Override provider bằng một StateNotifier đơn giản trả về state giả lập
            movieListNotifierProvider.overrideWith((ref) => MockMovieListNotifier(initialState)),
            // Cần override cả translationsProvider nếu nó có logic phức tạp
            languageProvider.overrideWith((ref) => AppLanguage.vi),
          ],
          child: const MaterialApp(
            home: SeeAllMoviesScreen(),
          ),
        ),
      );

      // Vì SeeAllMoviesScreen có logic fetchMovies khi khởi tạo, 
      // ta cần dùng pump() để trigger các thay đổi ban đầu
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Hiển thị thông báo lỗi khi fetch dữ liệu thất bại', (WidgetTester tester) async {
      const errorMessage = "Kết nối internet bị gián đoạn";
      final errorState = MovieListState.initial().copyWith(
        isLoading: false,
        error: errorMessage,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            movieListNotifierProvider.overrideWith((ref) => MockMovieListNotifier(errorState)),
            languageProvider.overrideWith((ref) => AppLanguage.vi),
          ],
          child: const MaterialApp(
            home: SeeAllMoviesScreen(),
          ),
        ),
      );

      await tester.pump();

      // Kiểm tra xem text lỗi có hiển thị đúng không (Theo format "Lỗi: $errorMessage")
      expect(find.textContaining('Lỗi:'), findsOneWidget);
      expect(find.textContaining(errorMessage), findsOneWidget);
      expect(find.text('Thử lại'), findsOneWidget);
    });
  });
}

// Mock class kế thừa StateNotifier trực tiếp để tránh lỗi Ref null
class MockMovieListNotifier extends StateNotifier<MovieListState> implements MovieListNotifier {
  MockMovieListNotifier(super.state);

  @override
  Ref<Object?> get ref => throw UnimplementedError();

  @override
  Future<void> fetchMovies({bool isRefresh = false}) async {}

  @override
  void reset() {}
}
