import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../models/history_item.dart';
import '../services/recommendation_service.dart';
import '../services/food_data_service.dart';
import '../l10n/app_localizations.dart';
import 'result_screen.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late Future<List<FoodItem>> _recommendationsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadRecommendations();
  }

  void _loadRecommendations() {
    final recommendationService =
        Provider.of<RecommendationService>(context, listen: false);
    final languageCode = Localizations.localeOf(context).languageCode;

    setState(() {
      _recommendationsFuture = recommendationService.getRecommendations(
          count: 5, languageCode: languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final foodDataService =
        Provider.of<FoodDataService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.explorePageTitle),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadRecommendations();
        },
        child: FutureBuilder<List<FoodItem>>(
          future: _recommendationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text('Öneriler yüklenirken bir hata oluştu.'));
            }

            final recommendations = snapshot.data ?? [];

            if (recommendations.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 4),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lightbulb_outline,
                              size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            "Sana Özel Öneriler Burada!",
                            style: theme.textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Birkaç yemeği favorilerine ekledikten sonra, damak zevkine uygun yeni lezzetleri burada göreceksin.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  "Favorilerine Göre Önerilerimiz",
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...recommendations
                    .map((food) =>
                        _buildRecommendationCard(food, foodDataService))
                    .toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
      FoodItem food, FoodDataService foodDataService) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          final tempHistoryItem = HistoryItem(
            imagePath: food.imageUrl,
            predictionLabel: food.id,
            confidence: 1.0,
            timestamp: DateTime.now(),
            isFavorite: false,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                imagePath: tempHistoryItem.imagePath,
                foodDataService: foodDataService,
                historyItem: tempHistoryItem,
              ),
            ),
          ).then((_) {
            // Detay sayfasından geri dönüldüğünde öneri listesini yenile
            // (kullanıcı favori durumunu değiştirmiş olabilir, bu yeni önerileri tetikleyebilir)
            _loadRecommendations();
          });
        },
        // --- EKSİK OLAN KISIM BURASIYDI ---
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Yemeğin resmini gösteren bölüm
            Image.asset(
              food.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Resim yüklenemezse bir yer tutucu göster
                return Container(
                  height: 150,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: Icon(Icons.image_not_supported_outlined,
                      color: Colors.grey[400], size: 40),
                );
              },
            ),
            // Metin ve etiketleri içeren bölüm
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.displayName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    food.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 12),
                  if (food.tags.isNotEmpty)
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: food.tags
                          .take(4)
                          .map((tag) => Chip(
                                label: Text(tag),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                labelStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                side: BorderSide.none,
                              ))
                          .toList(),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
