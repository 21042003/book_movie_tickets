import 'package:flutter/material.dart';

class AppSpacing {
  // Spacing
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;

  // EdgeInsets
  static const EdgeInsets edgeAll8 = EdgeInsets.all(s8);
  static const EdgeInsets edgeAll12 = EdgeInsets.all(s12);
  static const EdgeInsets edgeAll16 = EdgeInsets.all(s16);
  static const EdgeInsets edgeAll24 = EdgeInsets.all(s24);

  static const EdgeInsets edgeH16 = EdgeInsets.symmetric(horizontal: s16);
  static const EdgeInsets edgeH24 = EdgeInsets.symmetric(horizontal: s24);
  static const EdgeInsets edgeV16 = EdgeInsets.symmetric(vertical: s16);

  // BorderRadii
  static final BorderRadius radius8 = BorderRadius.circular(8.0);
  static final BorderRadius radius12 = BorderRadius.circular(12.0);
  static final BorderRadius radius16 = BorderRadius.circular(16.0);
  static final BorderRadius radius24 = BorderRadius.circular(24.0);
  static final BorderRadius radius30 = BorderRadius.circular(30.0);
}
