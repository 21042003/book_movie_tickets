import 'package:flutter/material.dart';

class CinemaList extends StatelessWidget {
  const CinemaList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        cinemaCard('Vincom Ocean Park CGV', '4.55 km | Da Ton, Gia Lam, Ha Noi', true),
        cinemaCard('Aeon Mall CGV', '9.32 km | 27 Co Linh, Long Bien, Ha Noi', false),
        cinemaCard('Aeon Mall CGV', '9.32 km | 27 Co Linh, Long Bien, Ha Noi', false),
      ],
    );
  }

  Widget cinemaCard(String name, String address, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? Colors.amber : Colors.white10),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(address, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.confirmation_num, color: Colors.red, size: 20),
        ],
      ),
    );
  }
}