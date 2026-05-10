import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'my_app.dart';
import 'core/utils/data_seeder.dart'; // Thêm import

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // BƯỚC KHỞI TẠO DỮ LIỆU:
  // 1. Nếu bạn vừa xóa 'showtimes' trên Firebase, hãy đảm bảo dòng dưới đây KHÔNG bị comment.
  // 2. Chạy app (Hot Restart), đợi log "✅ Đã khởi tạo dữ liệu thành công!".
  // 3. Sau khi dữ liệu đã lên Firebase, hãy comment lại dòng này để tối ưu tốc độ khởi động.
  await DataSeeder.seedInitialData();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(const ProviderScope(child:MyApp()));
}

