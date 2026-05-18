import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/language_provider.dart';

class AuthFooter extends ConsumerWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translationsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Text(
        tr.footerText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 12,
          height: 1.5,
        ),
      ),
    );
  }
}
