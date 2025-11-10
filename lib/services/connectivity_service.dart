import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Serwis do monitorowania połączenia z internetem
class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<List<ConnectivityResult>>? _subscription;
  static final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  static bool _isConnected = true;

  /// Stream informujący o zmianach połączenia
  static Stream<bool> get connectionStream => _connectionController.stream;

  /// Sprawdza czy jest połączenie
  static bool get isConnected => _isConnected;

  /// Inicjalizuje monitoring połączenia
  static Future<void> initialize() async {
    // Sprawdź początkowy stan
    final result = await _connectivity.checkConnectivity();
    _isConnected = !result.contains(ConnectivityResult.none);

    // Nasłuchuj zmian
    _subscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final wasConnected = _isConnected;
      _isConnected = !results.contains(ConnectivityResult.none);

      if (wasConnected != _isConnected) {
        _connectionController.add(_isConnected);
        if (kDebugMode) {
          debugPrint('Zmiana połączenia: $_isConnected');
        }
      }
    });
  }

  /// Sprawdza aktualny stan połączenia
  static Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    _isConnected = !result.contains(ConnectivityResult.none);
    return _isConnected;
  }

  /// Zamyka monitoring
  static void dispose() {
    _subscription?.cancel();
    _connectionController.close();
  }
}
