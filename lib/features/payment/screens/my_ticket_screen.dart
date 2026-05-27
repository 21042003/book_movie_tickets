import 'package:book_movie_tickets/core/localization/language_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:book_movie_tickets/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../home/models/movie_model.dart';
import '../models/booking_model.dart';

class MyTicketScreen extends ConsumerWidget {
  final BookingModel booking;
  final MovieModel movie;

  const MyTicketScreen({super.key, required this.booking, required this.movie});

  String _formatRuntime(int minutes, AppLanguage tr) {
    if (minutes <= 0) return 'N/A';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours > 0) {
      return '$hours ${tr.hourLabel} $remainingMinutes ${tr.minuteLabel}';
    } else {
      return '$remainingMinutes ${tr.minuteLabel}';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translationsProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: Text(
          tr.myTicket,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Stack(
          children: [
            // White Ticket Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Upper Part
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                width: 100,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildIconText(
                                    Icons.access_time,
                                    _formatRuntime(movie.runtime, tr),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildIconText(
                                    Icons.videocam_outlined,
                                    movie.genres.map((e) => e.name).join(', '),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: Colors.grey, thickness: 0.5),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildInfoColumn(
                                Icons.calendar_month,
                                booking.bookingTime,
                                booking.bookingDate,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInfoColumn(
                                Icons.event_seat,
                                tr.section + ' 4',
                                '${tr.seat} ${booking.seats.join(', ')}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.grey, thickness: 0.5),
                        const SizedBox(height: 16),
                        _buildSummaryRow(
                          Icons.monetization_on_outlined,
                          NumberFormat.currency(
                            locale: 'vi_VN',
                            symbol: 'VND',
                          ).format(booking.totalAmount),
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryRow(
                          Icons.location_on_outlined,
                          booking.cinemaName,
                          isCinema: true,
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryRow(
                          Icons.info_outline,
                          tr.showQrCode,
                        ),
                      ],
                    ),
                  ),

                  // Notch and Dashed Line Area
                  const SizedBox(height: 20), // Placeholder for notches
                  // Bottom Part (Barcode)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Column(
                      children: [
                        BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: booking.orderId,
                          width: double.infinity,
                          height: 80,
                          drawText: false,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${tr.orderId}: ${booking.orderId}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Notches and Dashed Line
            Positioned(
              left: 0,
              right: 0,
              bottom: 140, // Adjust based on bottom part height
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(
                              (constraints.constrainWidth() / 10).floor(),
                              (index) => const SizedBox(
                                width: 5,
                                height: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: Colors.grey),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(IconData icon, String topText, String bottomText) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.black, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                topText,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                bottomText,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(IconData icon, String text, {bool isCinema = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.black, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isCinema)
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                            child: Image.asset(
                              fit: BoxFit.cover,
                              AppIcons.cgv,
                              width: 36,
                              height: 16,
                            ),
                          ),
                          // Icon(Icons.movie, color: Colors.red, size: 16),
                        ),
                      ),
                  ],
                ),
              ),
              if (isCinema)
                Text(
                  booking.cinemaAddress,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
