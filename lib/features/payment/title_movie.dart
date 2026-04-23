import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_image.dart';

class TitleMovie extends StatelessWidget {
  const TitleMovie({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 398.0,
            height: 141.0,
            decoration: BoxDecoration(
              color: AppColors.hex1C1C1C,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    bottomLeft: Radius.circular(16.0),
                  ),
                  child: Image.asset(AppImage.avatar, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16,),
                        child: Text(
                          'Black Panther: Wakanda',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.hexFCC434,
                          ),
                        ),
                      ),
                      _buildLegendItem(Icons.import_contacts_sharp, '12',),
                      _buildLegendItem(Icons.import_contacts_sharp, '12',),
                      _buildLegendItem(Icons.insert_chart_outlined_sharp,'12',),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Thêm kiểu 'String' cho text và label
Widget _buildLegendItem(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, size: 16, color: AppColors.hex8C8C8C),
      const SizedBox(width: 4.0),
      // Thay chuỗi cố định '12+' bằng biến text
      Text(text),
      // Nếu bạn muốn dùng cả label, có thể nối chuỗi: Text('$label: $text')
    ],
  );
}
