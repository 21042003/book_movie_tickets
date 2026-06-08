import 'package:book_movie_tickets/features/home/screens/see_all_movies_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../authentication/repository/auth_repository.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../core/widgets/see_all_click.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/constants/app_spacing.dart';
import '../../payment/screens/ticket_list_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../controllers/see_all_movies_controller.dart';
import '../widgets/coming_soon_section.dart';
import '../widgets/home_header.dart';
import '../widgets/movie_card.dart';
import '../widgets/search_bar_widget.dart';
import 'search_screen.dart';

/// [HomeScreen] sử dụng [ConsumerStatefulWidget] để kết hợp Lifecycle của Flutter
/// và khả năng lắng nghe State từ các Provider của Riverpod.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Quản lý nội dung trong thanh tìm kiếm.
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Giải phóng bộ nhớ của controller khi widget bị hủy. 
    // Đây là bước quan trọng để tránh Memory Leak (Rò rỉ bộ nhớ).
    _controller.dispose();
    super.dispose();
  }

  /// Hàm xử lý khi người dùng nhấn vào các mục ở thanh điều hướng phía dưới.
  /// Sử dụng [Navigator.pushReplacement] để thay thế màn hình hiện tại, 
  /// giúp Stack Navigation không bị quá tải bộ nhớ.
  void _onItemTapped(int index) {
    if (index == 0) return; // Nếu đang ở Home thì không làm gì.

    Widget nextScreen;
    switch (index) {
      case 1:
        nextScreen = const TicketListScreen();
        break;
      case 2:
        nextScreen = const SeeAllMoviesScreen();
        break;
      case 3:
        nextScreen = const ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch(translationsProvider) giúp tự động cập nhật ngôn ngữ khi User thay đổi cài đặt.
    final tr = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          // Sử dụng ListView để toàn bộ trang có thể cuộn được, tránh lỗi pixel overflow trên màn hình nhỏ.
          children: [
            // Header hiển thị tên User và vị trí.
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

            // Thanh tìm kiếm ở trang Home đóng vai trò là nút chuyển sang trang SearchScreen.
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

            const SizedBox(height: AppSpacing.s16),

            // Section: Phim đang chiếu
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
            const SizedBox(height: AppSpacing.s16),
            const MovieCard(),

            const SizedBox(height: AppSpacing.s24),

            // Section: Phim sắp chiếu
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
            const SizedBox(height: AppSpacing.s16),
            const ComingSoonList(),

            const SizedBox(height: AppSpacing.s24),

            // Section: Khuyến mãi
            SeeAllClick(title: tr.promoDiscount, onTap: () {}),
            const SizedBox(height: AppSpacing.s20),
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
