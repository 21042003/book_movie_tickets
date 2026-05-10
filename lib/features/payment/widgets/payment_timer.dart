import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PaymentTimer extends StatefulWidget {
  final int initialSeconds;
  const PaymentTimer({super.key, this.initialSeconds = 900});

  @override
  State<PaymentTimer> createState() => _PaymentTimerState();
}

class _PaymentTimerState extends State<PaymentTimer> {
  late Timer _timer;
  late int _secondsRemaining;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.initialSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        _timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.hex1C1C1C,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Complete your payment in', style: TextStyle(color: Colors.white)),
          Text(
            _formatTime(_secondsRemaining),
            style: const TextStyle(color: AppColors.hexFCC434, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
