import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/success_dialog.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/auth_button.dart';
import '../view_model/auth_view_model.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _listenToAuthState() {
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.generalError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.generalError!),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(authViewModelProvider.notifier).clearErrors();
      }
      if (next.isSuccess) {
        ref.read(authViewModelProvider.notifier).clearErrors();
        
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => SuccessDialog(
            title: 'Đăng ký thành công!',
            message: 'Tài khoản của bạn đã được tạo. Vui lòng đăng nhập để tiếp tục.',
          ),
        ).then((_) {
          // Khi Dialog đóng (do nhấn nút "Tuyệt vời"), quay lại màn hình Login
          if (mounted) {
            Navigator.pop(context);
          }
        });

        // Tự động đóng Dialog sau 2 giây nếu người dùng không nhấn nút
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context); // Đóng Dialog
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listenToAuthState();
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            ref.read(authViewModelProvider.notifier).clearErrors();
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sign up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            CustomTextField(
              label: 'Full Name',
              controller: _fullNameController,
              errorText: authState.fullNameError,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: authState.emailError,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Password',
              isPassword: true,
              controller: _passwordController,
              errorText: authState.passwordError,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Confirm Password',
              isPassword: true,
              controller: _confirmPasswordController,
              errorText: authState.confirmPasswordError,
            ),
            const SizedBox(height: 40),
            AuthButton(
              text: 'Sign up',
              isLoading: authState.isLoading,
              onPressed: () {
                ref.read(authViewModelProvider.notifier).signUp(
                  fullName: _fullNameController.text,
                  email: _emailController.text,
                  password: _passwordController.text,
                  confirmPassword: _confirmPasswordController.text,
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(color: Colors.white70),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: AppColors.hexFCC434,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
