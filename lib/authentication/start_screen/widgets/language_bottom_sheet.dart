import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_provider.dart';


class LanguageBottomSheet extends ConsumerStatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  ConsumerState<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends ConsumerState<LanguageBottomSheet> {
  late AppLanguage _selectedTemp;

  @override
  void initState() {
    super.initState();
    _selectedTemp = ref.read(languageProvider);
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.hex1C1C1C,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedTemp.chooseLanguage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedTemp.whichLanguage,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),
          _buildLanguageItem(AppLanguage.en),
          const Divider(color: Colors.white10),
          _buildLanguageItem(AppLanguage.vi),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                ref.read(languageProvider.notifier).state = _selectedTemp;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.hexFCC434,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                _selectedTemp.useButtonText,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(AppLanguage lang) {
    final isSelected = _selectedTemp == lang;
    return GestureDetector(
      onTap: () => setState(() => _selectedTemp = lang),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lang.name,
              style: TextStyle(
                color: isSelected ? AppColors.hexFCC434 : Colors.white,
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.hexFCC434 : Colors.white30,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.hexFCC434,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
