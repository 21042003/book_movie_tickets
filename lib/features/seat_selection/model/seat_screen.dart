import 'package:flutter/material.dart';

import '../seat_text.dart';

class SeatScreen extends StatelessWidget {
  const SeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // CinemaBooking(),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              width: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return SeatText();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
