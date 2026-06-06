import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NetworkStatus { connected, disconnected }

final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

final networkStatusProvider = Provider<NetworkStatus>((ref) {
  final connectivity = ref.watch(connectivityProvider);

  return connectivity.maybeWhen(
    data: (results) {
      if (results.contains(ConnectivityResult.none)) {
        return NetworkStatus.disconnected;
      }
      return NetworkStatus.connected;
    },
    orElse: () => NetworkStatus.connected, // Mặc định là có mạng khi chưa load xong
  );
});
