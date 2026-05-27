import 'package:book_movie_tickets/core/database/database_provider.dart';
import 'package:book_movie_tickets/core/localization/language_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/models/movie_model.dart';
import '../models/booking_model.dart';
import 'my_ticket_screen.dart';

class QRPaymentScreen extends ConsumerStatefulWidget {
  final BookingModel booking;
  final MovieModel movie;

  const QRPaymentScreen({super.key, required this.booking, required this.movie});

  @override
  ConsumerState<QRPaymentScreen> createState() => _QRPaymentScreenState();
}

class _QRPaymentScreenState extends ConsumerState<QRPaymentScreen> {
  bool _isProcessing = false;

  void _simulateSuccess() async {
    setState(() {
      _isProcessing = true;
    });

    // Save to local SQLite database
    try {
      final dbHelper = ref.read(databaseHelperProvider);
      await dbHelper.insertBooking(widget.booking);
    } catch (e) {
      debugPrint('Error saving to SQLite: $e');
    }

    // Giả lập thời gian chờ phản hồi từ ngân hàng/ví điện tử
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyTicketScreen(
            booking: widget.booking,
            movie: widget.movie,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(tr.qrPayment, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    widget.booking.paymentMethod,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(widget.booking.totalAmount),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  BarcodeWidget(
                    barcode: Barcode.qrCode(),
                    data: 'PAYMENT_ORDER_${widget.booking.orderId}',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    tr.scanQrToPay,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            if (_isProcessing)
              Column(
                children: [
                  const CircularProgressIndicator(color: AppColors.hexFCC434),
                  const SizedBox(height: 16),
                  Text(tr.confirmingPayment,
                      style: const TextStyle(color: Colors.white)),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simulateSuccess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.hexFCC434,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(tr.confirmTransfer,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              tr.doNotCloseApp,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
