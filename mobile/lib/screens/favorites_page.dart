import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/history_item.dart';
import '../services/history_service.dart';
import '../services/food_data_service.dart';
import '../l10n/app_localizations.dart';
import 'result_screen.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final HistoryService _historyService = HistoryService();
  late Future<List<HistoryItem>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favoritesFuture = _historyService.getHistory().then((historyList) {
        return historyList.where((item) => item.isFavorite).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    // --- YENİ: FoodDataService'i build metodunun en başında alıyoruz ---
    final foodDataService =
        Provider.of<FoodDataService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorilerim"), // TODO: ARB'ye ekle
        centerTitle: true,
      ),
      body: FutureBuilder<List<HistoryItem>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          final favoritesList = snapshot.data ?? [];

          if (favoritesList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "Henüz Favoriniz Yok",
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      "Geçmiş sayfasındaki kalp ikonuna dokunarak favorilerinizi ekleyebilirsiniz.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: favoritesList.length,
            itemBuilder: (context, index) {
              final item = favoritesList[index];
              // --- DEĞİŞİKLİK BURADA: foodDataService'i parametre olarak gönderiyoruz ---
              return _buildFavoriteCard(item, foodDataService);
            },
          );
        },
      ),
    );
  }

  // --- DEĞİŞİKLİK BURADA: Metot artık foodDataService parametresi alıyor ---
  Widget _buildFavoriteCard(HistoryItem item, FoodDataService foodDataService) {
    final formattedDate = DateFormat(
            'd MMMM y, HH:mm', Localizations.localeOf(context).languageCode)
        .format(item.timestamp);
    final formattedLabel = item.predictionLabel
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            File(item.imagePath),
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              );
            },
          ),
        ),
        title: Text(
          formattedLabel,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle:
            Text(formattedDate, style: TextStyle(color: Colors.grey[600])),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                imagePath: item.imagePath,
                foodDataService: foodDataService,
                historyItem: item,
              ),
            ),
          ).then((_) {
            _loadFavorites();
          });
        },
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.redAccent),
          onPressed: () async {
            await _historyService.toggleFavoriteStatus(item.timestamp);
            _loadFavorites();
          },
        ),
      ),
    );
  }
}
