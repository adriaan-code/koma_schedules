import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

/// Narzędzie do wyciągnięcia wszystkich unikalnych wartości main_container z API
/// Użycie: wywołaj getAllMainContainers() i sprawdź logi w konsoli
Future<void> printAllMainContainers() async {
  try {
    final apiService = ApiService();
    final containers = await apiService.getAllMainContainers();
    
    debugPrint('========================================');
    debugPrint('WSZYSTKIE UNIKALNE POJEMNIKI (main_container):');
    debugPrint('========================================');
    debugPrint('Liczba unikalnych pojemników: ${containers.length}');
    debugPrint('');
    
    for (int i = 0; i < containers.length; i++) {
      debugPrint('${i + 1}. ${containers[i]}');
    }
    
    debugPrint('');
    debugPrint('========================================');
  } catch (e) {
    debugPrint('Błąd pobierania pojemników: $e');
  }
}

