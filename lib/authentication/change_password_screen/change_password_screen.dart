import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/success_dialog.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/auth_button.dart';
import '../view_model/auth_view_model.dart';
import '../../../core/localization/language_provider.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).clearErrors();
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _listenToAuthState() {
    final tr = ref.read(translationsProvider);
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
            title: tr.changePasswordSuccess,
            message: tr.changePasswordSuccessDesc,
          ),
        ).then((_) {
          if (mounted) {
            Navigator.pop(context);
          }
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listenToAuthState();
    final authState = ref.watch(authViewModelProvider);
    final tr = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          tr.changePassword,
          style: const TextStyle(color: Colors.white),
        ),
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
            const SizedBox(height: 20),
            CustomTextField(
              label: tr.currentPassword,
              isPassword: true,
              controller: _currentPasswordController,
              errorText: authState.currentPasswordError,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: tr.newPassword,
              isPassword: true,
              controller: _newPasswordController,
              errorText: authState.passwordError,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: tr.confirmPassword,
              isPassword: true,
              controller: _confirmPasswordController,
              errorText: authState.confirmPasswordError,
            ),
            const SizedBox(height: 40),
            AuthButton(
              text: tr.changePassword,
              isLoading: authState.isLoading,
              onPressed: () {
                ref.read(authViewModelProvider.notifier).changePassword(
                  currentPassword: _currentPasswordController.text,
                  newPassword: _newPasswordController.text,
                  confirmPassword: _confirmPasswordController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
