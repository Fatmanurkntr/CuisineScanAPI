import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

class HistoryService {
  static const String _historyKey = 'scanHistory';

  // Geçmiş listesini cihazdan okuyan fonksiyon.
  Future<List<HistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? historyJson = prefs.getStringList(_historyKey);

    if (historyJson == null) {
      return [];
    }

    // JSON String listesini, HistoryItem nesnelerine dönüştürüyoruz.
    return historyJson
        .map((item) => HistoryItem.fromJson(jsonDecode(item)))
        .toList();
  }

  // Yeni bir tarama sonucunu geçmişe ekleyen fonksiyon.
  Future<void> addToHistory(HistoryItem newItem) async {
    final prefs = await SharedPreferences.getInstance();
    final List<HistoryItem> currentHistory = await getHistory();

    // Yeni öğeyi listenin başına ekliyoruz.
    currentHistory.insert(0, newItem);

    final List<String> historyJson =
        currentHistory.map((item) => jsonEncode(item.toJson())).toList();

    await prefs.setStringList(_historyKey, historyJson);
    print("Yeni öğe geçmişe eklendi: ${newItem.predictionLabel}");
  }

  // Bir öğenin favori durumunu değiştiren fonksiyon.
  Future<void> toggleFavoriteStatus(DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    final List<HistoryItem> currentHistory = await getHistory();
    final int itemIndex =
        currentHistory.indexWhere((item) => item.timestamp == timestamp);

    if (itemIndex != -1) {
      currentHistory[itemIndex].isFavorite =
          !currentHistory[itemIndex].isFavorite;

      final List<String> historyJson =
          currentHistory.map((item) => jsonEncode(item.toJson())).toList();

      await prefs.setStringList(_historyKey, historyJson);
      print(
          "Öğenin favori durumu değiştirildi: ${currentHistory[itemIndex].predictionLabel}");
    }
  }

  // --- YENİ EKLENEN FONKSİYON ---
  // Geçmişten tek bir öğeyi, timestamp'ine göre silen fonksiyon.
  Future<void> removeFromHistory(DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    final List<HistoryItem> currentHistory = await getHistory();

    // Verilen timestamp'e sahip öğeyi listeden çıkarıyoruz.
    currentHistory.removeWhere((item) => item.timestamp == timestamp);

    final List<String> historyJson =
        currentHistory.map((item) => jsonEncode(item.toJson())).toList();

    await prefs.setStringList(_historyKey, historyJson);
    print("Bir öğe geçmişten silindi: $timestamp");
  }

  // Geçmişi tamamen temizleyen fonksiyon.
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    print("Geçmiş temizlendi.");
  }
}
