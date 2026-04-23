import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/cinema_selection_provider.dart';

class CinemaList extends ConsumerWidget {
  const CinemaList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCinema = ref.watch(selectedCinemaProvider);

    return Column(
      children: [
        _cinemaCard(
          ref,
          'Vincom Ocean Park CGV',
          '4.55 km | Da Ton, Gia Lam, Ha Noi',
          selectedCinema == 'Vincom Ocean Park CGV',
        ),
        _cinemaCard(
          ref,
          'Aeon Mall CGV Long Bien',
          '9.32 km | 27 Co Linh, Long Bien, Ha Noi',
          selectedCinema == 'Aeon Mall CGV Long Bien',
        ),
        _cinemaCard(
          ref,
          'CGV Vincom Ba Trieu',
          '9.32 km | 191 Ba Trieu, Hai Ba Trung, Ha Noi',
          selectedCinema == 'CGV Vincom Ba Trieu',
        ),
      ],
    );
  }

  Widget _cinemaCard(WidgetRef ref, String name, String address, bool isSelected) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedCinemaProvider.notifier).state = name;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFCC434) : Colors.white10,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected 
              ? const Color(0xFFFCC434).withOpacity(0.1) 
              : Colors.white.withOpacity(0.05),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFFFCC434) : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    address,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.confirmation_num,
              color: isSelected ? const Color(0xFFFCC434) : Colors.red,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
