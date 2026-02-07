import '../models/food_item.dart';
import '../models/history_item.dart';
import 'food_data_service.dart';
import 'history_service.dart';

class RecommendationService {
  final FoodDataService _foodDataService;
  final HistoryService _historyService;

  // Bu servis, çalışmak için diğer iki servise ihtiyaç duyar.
  // Onları constructor aracılığıyla alıyoruz.
  RecommendationService({
    required FoodDataService foodDataService,
    required HistoryService historyService,
  })  : _foodDataService = foodDataService,
        _historyService = historyService;

  // Ana öneri fonksiyonumuz
  Future<List<FoodItem>> getRecommendations(
      {int count = 3, required String languageCode}) async {
    // 1. Adım: Kullanıcının favorilerini ve geçmişini al.
    final List<HistoryItem> history = await _historyService.getHistory();
    final List<HistoryItem> favorites =
        history.where((item) => item.isFavorite).toList();

    // Eğer yeterli favori yoksa (örn: 1'den az), öneri yapma ve boş liste döndür.
    if (favorites.isEmpty) {
      return [];
    }

    // 2. Adım: Favori yemeklerin etiketlerinden bir "ilgi profili" oluştur.
    // Hangi etiketin kaç kez favorilendiğini sayacağız.
    final Map<String, int> userProfileTags = {};
    for (var favItem in favorites) {
      // Favori yemeğin detaylarını (ve etiketlerini) JSON'dan al.
      final foodDetails = _foodDataService
          .getFoodDetails(favItem.predictionLabel, languageCode: languageCode);
      if (foodDetails != null && foodDetails.tags.isNotEmpty) {
        for (var tag in foodDetails.tags) {
          // Etiketi profile ekle ve sayacını bir artır.
          userProfileTags.update(tag, (value) => value + 1, ifAbsent: () => 1);
        }
      }
    }

    // Eğer favorilerden hiç etiket çıkarılamadıysa, devam etme.
    if (userProfileTags.isEmpty) {
      return [];
    }

    // 3. Adım: Tüm yemekleri, kullanıcının profiline ne kadar benzediklerine göre puanla.
    final List<FoodItem> allFoods =
        _foodDataService.getAllFoodItems(languageCode);
    final Map<FoodItem, int> recommendationScores = {};

    for (var food in allFoods) {
      // Kullanıcının daha önce taradığı (geçmişindeki) yemekleri önerme.
      if (history.any((histItem) => histItem.predictionLabel == food.id)) {
        continue; // Bu yemeği atla ve bir sonrakine geç
      }

      int score = 0;
      // Yemeğin her bir etiketi için, eğer kullanıcının profilinde varsa,
      // o etiketin popülerlik sayısını (ağırlığını) puana ekle.
      for (var tag in food.tags) {
        if (userProfileTags.containsKey(tag)) {
          score += userProfileTags[tag]!;
        }
      }

      if (score > 0) {
        recommendationScores[food] = score;
      }
    }

    // 4. Adım: Yemekleri puanlarına göre büyükten küçüğe sırala.
    var sortedRecommendations = recommendationScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // 5. Adım: En yüksek puanlı 'count' adet yemeği al ve döndür.
    return sortedRecommendations.take(count).map((entry) => entry.key).toList();
  }
}
