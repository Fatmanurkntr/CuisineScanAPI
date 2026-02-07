// Bu dosya, tek bir yemekle ilgili tüm bilgileri tutan "kalıp" sınıflarımızı içerir.

// Besin değeri bilgilerini tutan yardımcı sınıf.
class NutritionInfo {
  final int caloriesPer100g;
  final int defaultServingSizeG;

  NutritionInfo({
    required this.caloriesPer100g,
    required this.defaultServingSizeG,
  });

  // JSON'dan (Map'ten) NutritionInfo nesnesi oluşturan metot.
  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      // JSON'daki 'calories_per_100g' anahtarını okur.
      caloriesPer100g: json['calories_per_100g'] ?? 0,
      // JSON'daki 'default_serving_size_g' anahtarını okur.
      defaultServingSizeG: json['default_serving_size_g'] ?? 0,
    );
  }
}

// Bir yemeğin tüm bilgilerini bir arada tutan ana sınıfımız.
class FoodItem {
  final String id; // Örn: "iskender"
  final String displayName; // Örn: "İskender Kebap"
  final String description;
  final String history;
  final List<String> mainIngredients;
  final List<String> tags; // Öneri sistemi için etiketler
  final NutritionInfo? nutritionInfo; // Besin değeri objesi
  final String imageUrl;

  FoodItem({
    required this.id,
    required this.displayName,
    required this.description,
    required this.history,
    required this.mainIngredients,
    required this.tags,
    required this.imageUrl,
    this.nutritionInfo,
  });

  // --- EN ÖNEMLİ DEĞİŞİKLİK BURADA ---
  // Bu metot, birleşik 'food_data.json' dosyamızdaki bir yemek objesini
  // okuyup, onu bir FoodItem nesnesine dönüştürür.
  factory FoodItem.fromJson(String id, Map<String, dynamic> json) {
    return FoodItem(
      id: id,
      // 'displayName' anahtarını okur, bulamazsa boş metin atar.
      displayName: json['displayName'] ?? '',
      description: json['description'] ?? '',
      history: json['history'] ?? '',
      // 'mainIngredients' listesini okur, bulamazsa boş liste atar.
      mainIngredients: List<String>.from(json['mainIngredients'] ?? []),
      // 'tags' listesini okur, bulamazsa boş liste atar.
      tags: List<String>.from(json['tags'] ?? []),
      // 'nutritionInfo' objesini okur. Eğer varsa, onu da NutritionInfo.fromJson ile
      // bir nesneye dönüştürür. Yoksa null atar.
      nutritionInfo: json['nutritionInfo'] != null &&
              (json['nutritionInfo'] as Map).isNotEmpty
          ? NutritionInfo.fromJson(json['nutritionInfo'])
          : null,
      imageUrl: json['imageUrl'] ?? 'assets/images/placeholder.jpg',
    );
  }
}
