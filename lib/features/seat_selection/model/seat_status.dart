import 'dart:ui';

import '../../../core/constants/app_colors.dart';

enum SeatStatus{
  available,
  Reserved,
  selected,
}

extension SeatStatusExtension on SeatStatus{
  Color get color{
    switch (this){
      case SeatStatus.available:
        return AppColors.hex1C1C1C;
      case SeatStatus.Reserved:
        return AppColors.hex261D08;
        case SeatStatus.selected:
        return AppColors.hexFCC434;
    }
  }

  String get label{
    switch(this){
      case SeatStatus.available:
        return "Trong";
      case SeatStatus.Reserved:
        return "Da dat";
      case SeatStatus.selected:
        return "Dang chon";
    }
  }
}