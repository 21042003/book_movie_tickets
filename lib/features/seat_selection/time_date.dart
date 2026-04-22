import 'package:flutter/material.dart';

class DemoLogicDatVe extends StatefulWidget {
  const DemoLogicDatVe({super.key});

  @override
  State<DemoLogicDatVe> createState() => _DemoLogicDatVeState();
}

class _DemoLogicDatVeState extends State<DemoLogicDatVe> {
  DateTime? ngay;
  String? gio;
  String ketQua = "Bạn chưa đặt vé";

  void chotVe(){
    if(ngay == null || gio == null){
      setState(() {
        ketQua = "Loi: Ban phai chon ca ngay va gio";
      });
      return;
    }
    List<String> haiManh = gio!.split(":");
    int soGio = int.parse(haiManh[0]);
    int soPhut = int.parse(haiManh[1]);

    DateTime veCuaBan = DateTime(ngay!.year, ngay!.month, ngay!.day, soGio, soPhut);

    setState(() {
      ketQua = "Thanh cong! Ve cua ban la: $veCuaBan";
    });
  }
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
