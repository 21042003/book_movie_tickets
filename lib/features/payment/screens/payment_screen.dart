import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../authentication/repository/auth_repository.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import '../../home/models/Api_service/movie_service.dart';
import '../../home/models/movie_model.dart';
import '../../seat_selection/model/firestore_models.dart';
import '../../seat_selection/model/seat_status.dart';
import '../../seat_selection/provider/seat_selection_provider.dart';
import '../../seat_selection/repository/showtime_repository.dart';
import '../widgets/discount_section.dart';
import '../widgets/order_info_section.dart';
import '../widgets/payment_method_section.dart';
import '../widgets/payment_movie_info.dart';
import '../widgets/payment_timer.dart';

import 'my_ticket_screen.dart';
import '../models/booking_model.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final int movieId;
  final String showtimeId;
  const PaymentScreen({super.key, required this.movieId, required this.showtimeId});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  late String _orderId;
  String _selectedPaymentMethod = 'Shopee Pay';

  @override
  void initState() {
    super.initState();
    _orderId = _generateOrderId();
  }

  String _generateOrderId() {
    return (Random().nextInt(900000000) + 7000000000).toString();
  }

  @override
  Widget build(BuildContext context) {
    final movieAsync = ref.watch(movieDetailProvider(widget.movieId));
    final showtimeAsync = ref.watch(firestoreShowtimeFullProvider(widget.showtimeId));
    final seatState = ref.watch(seatSelectionProvider);
    final tr = ref.watch(translationsProvider);
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

    final selectedSeats = seatState.seats
        .where((seat) => seat.status == SeatStatus.selected)
        .map((seat) => seat.label)
        .join(', ');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          tr.payment,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: movieAsync.when(
        data: (movie) => showtimeAsync.when(
          data: (showtime) => SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentMovieInfo(
                  movie: movie,
                  selectedCinema: showtime.cinemaName,
                  selectedDate: showtime.startTime,
                  selectedTime: DateFormat('HH:mm').format(showtime.startTime),
                ),
                const SizedBox(height: 24),
                OrderInfoSection(
                  orderId: _orderId,
                  selectedSeats: selectedSeats,
                ),
                const SizedBox(height: 24),
                const DiscountSection(),
                const SizedBox(height: 24),
                const Divider(color: Colors.grey, thickness: 0.5),
                const SizedBox(height: 16),
                _buildTotalRow(currencyFormat, seatState.totalAmount, tr.total),
                const SizedBox(height: 24),
                PaymentMethodSection(
                  selectedMethod: _selectedPaymentMethod,
                  onMethodSelected: (method) =>
                      setState(() => _selectedPaymentMethod = method),
                ),
                const SizedBox(height: 24),
                const PaymentTimer(),
                const SizedBox(height: 24),
                _buildContinueButton(movie, showtime, seatState, tr),
                const SizedBox(height: 40),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text("Error: $e", style: const TextStyle(color: Colors.red))),
        ),
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.hexFCC434)),
        error: (err, stack) => Center(
            child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildTotalRow(NumberFormat format, double amount, String totalLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(totalLabel, style: const TextStyle(color: Colors.white, fontSize: 16)),
        Text(
          format.format(amount),
          style: const TextStyle(
            color: AppColors.hexFCC434,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(MovieModel movie, ShowtimeFirestoreModel showtime, SeatSelectionState seatState, AppLanguage tr) {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final selectedSeatLabels = seatState.seats
                .where((seat) => seat.status == SeatStatus.selected)
                .map((seat) => seat.label)
                .toList();

          if (selectedSeatLabels.isEmpty) {
            return;
          }

          try {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(color: AppColors.hexFCC434),
              ),
            );

            await ref.read(showtimeRepositoryProvider).bookSeats(
              showtimeId: widget.showtimeId,
              seatLabels: selectedSeatLabels,
              userId: user.uid, 
              totalAmount: seatState.totalAmount,
              movieTitle: movie.title,
              moviePoster: movie.posterPath,
              cinemaName: showtime.cinemaName,
              cinemaAddress: showtime.cinemaAddress,
              bookingDate: DateFormat('dd.MM.yyyy').format(showtime.startTime),
              bookingTime: DateFormat('HH:mm').format(showtime.startTime),
              paymentMethod: _selectedPaymentMethod,
              orderId: _orderId,
            );

            if (mounted) {
              Navigator.pop(context); 

              final booking = BookingModel(
                userId: user.uid,
                movieId: movie.id,
                movieTitle: movie.title,
                moviePoster: movie.posterPath,
                cinemaName: showtime.cinemaName,
                cinemaAddress: showtime.cinemaAddress,
                bookingDate: DateFormat('dd.MM.yyyy').format(showtime.startTime),
                bookingTime: DateFormat('HH:mm').format(showtime.startTime),
                seats: selectedSeatLabels,
                totalAmount: seatState.totalAmount,
                paymentMethod: _selectedPaymentMethod,
                orderId: _orderId,
                createdAt: DateTime.now(),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyTicketScreen(
                    booking: booking,
                    movie: movie,
                  ),
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.hexFCC434,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(tr.continueBtn,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
