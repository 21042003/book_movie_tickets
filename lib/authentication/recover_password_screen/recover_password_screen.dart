import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/success_dialog.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/auth_button.dart';
import '../view_model/auth_view_model.dart';
import '../../../core/localization/language_provider.dart';

class RecoverPasswordScreen extends ConsumerStatefulWidget {
  const RecoverPasswordScreen({super.key});

  @override
  ConsumerState<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends ConsumerState<RecoverPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
      if (next.isSuccess && !next.isLoading && next.emailError == null && next.generalError == null) {
        ref.read(authViewModelProvider.notifier).clearErrors();
        
        SuccessDialog.show(
          context,
          title: tr.requestSent,
          message: tr.checkEmailDesc,
        );

        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            Navigator.pop(context); // Close Dialog
            Navigator.pop(context); // Back to Login
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            ref.read(authViewModelProvider.notifier).clearErrors();
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.forgotPasswordTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tr.recoverPasswordDesc,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 40),
            CustomTextField(
              label: tr.email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: authState.emailError,
            ),
            const SizedBox(height: 40),
            AuthButton(
              text: tr.sendLink,
              isLoading: authState.isLoading,
              onPressed: () {
                ref.read(authViewModelProvider.notifier).recoverPassword(
                  _emailController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
