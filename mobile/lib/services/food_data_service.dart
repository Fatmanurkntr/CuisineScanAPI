import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/food_item.dart';

class FoodDataService {
  // Tüm dillerdeki yemek verilerini tek bir yerde tutacağız.
  Map<String, dynamic>? _allFoodData;
  bool _isDataLoaded = false;

  // Veri yükleme fonksiyonu. Artık sadece BİR dosya yüklüyor.
  Future<void> loadAllData() async {
    if (_isDataLoaded) return;

    try {
      // Python script'inin oluşturduğu ana veri dosyasını yüklüyoruz.
      final jsonString =
          await rootBundle.loadString('assets/data/food_data.json');
      _allFoodData = json.decode(jsonString);
      _isDataLoaded = true;
      print("Ana yemek veritabanı ('food_data.json') başarıyla yüklendi.");
    } catch (e) {
      print(
          "HATA: 'food_data.json' yüklenemedi. 'scripts/combine_data.py' script'ini çalıştırdınız mı?");
      print("Detay: $e");
    }
  }

  // Belirli bir yemeğin detaylarını getiren fonksiyon.
  FoodItem? getFoodDetails(String foodId, {required String languageCode}) {
    if (!_isDataLoaded || _allFoodData == null) return null;

    // Önce dil verisini, sonra o dildeki yemeği alıyoruz.
    final languageData = _allFoodData![languageCode] as Map<String, dynamic>?;
    if (languageData == null) return null;

    final foodJson = languageData[foodId] as Map<String, dynamic>?;

    if (foodJson != null) {
      // Modeli kullanarak JSON'ı FoodItem nesnesine dönüştürüyoruz.
      return FoodItem.fromJson(foodId, foodJson);
    }

    return null;
  }

  // Belirli bir dildeki TÜM yemekleri liste olarak getiren fonksiyon.
  // Bu, öneri sistemi için çok önemli olacak.
  List<FoodItem> getAllFoodItems(String languageCode) {
    if (!_isDataLoaded || _allFoodData == null) return [];

    final languageData = _allFoodData![languageCode] as Map<String, dynamic>?;
    if (languageData == null) return [];

    // Haritadaki her bir anahtar-değer çiftini bir FoodItem nesnesine dönüştürüyoruz.
    return languageData.entries.map((entry) {
      final foodId = entry.key;
      final foodJson = entry.value as Map<String, dynamic>;
      return FoodItem.fromJson(foodId, foodJson);
    }).toList();
  }
}
