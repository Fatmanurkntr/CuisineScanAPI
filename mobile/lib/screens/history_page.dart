import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/history_item.dart';
import '../services/history_service.dart';
import '../services/food_data_service.dart';
import '../l10n/app_localizations.dart';
import 'result_screen.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryService _historyService = HistoryService();
  late Future<List<HistoryItem>> _historyFuture;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = _historyService.getHistory();
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final foodDataService =
        Provider.of<FoodDataService>(context, listen: false);

    return Scaffold(
      body: FutureBuilder<List<HistoryItem>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          final historyList = snapshot.data ?? [];

          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.tabHistory),
              centerTitle: true,
              actions: [
                if (historyList.isNotEmpty)
                  TextButton(
                    onPressed: _toggleEditMode,
                    child: Text(
                      _isEditing ? "Bitti" : "Düzenle",
                      style: TextStyle(
                          color: _isEditing
                              ? Colors.redAccent
                              : theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                if (!_isEditing && historyList.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      // --- EKSİK KISIM DOLDURULDU ---
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Geçmişi Temizle"),
                          content: const Text(
                              "Tüm tarama geçmişinizi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz."),
                          actions: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("İptal")),
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("Sil",
                                    style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await _historyService.clearHistory();
                        _loadHistory();
                      }
                    },
                  ),
              ],
            ),
            body: Builder(
              builder: (context) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Bir hata oluştu: ${snapshot.error}'));
                }
                if (historyList.isEmpty) {
                  // --- EKSİK KISIM DOLDURULDU ---
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark_border,
                            size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(l10n.historyEmptyTitle,
                            style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            l10n.historyEmptySubtitle,
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
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final item = historyList[index];
                    return _buildHistoryCard(item, foodDataService);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(HistoryItem item, FoodDataService foodDataService) {
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
      child: Row(
        children: [
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Öğeyi Sil"),
                      content: Text(
                          "'$formattedLabel' öğesini geçmişten kalıcı olarak silmek istediğinizden emin misiniz?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("İptal")),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await _historyService
                                .removeFromHistory(item.timestamp);
                            _loadHistory();
                          },
                          child: const Text("Sil",
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          Expanded(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                // --- EKSİK KISIM DOLDURULDU ---
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
              title: Text(formattedLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(formattedDate,
                  style: TextStyle(color: Colors.grey[600])),
              trailing: IconButton(
                icon: Icon(
                    item.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: item.isFavorite ? Colors.redAccent : Colors.grey),
                onPressed: () async {
                  await _historyService.toggleFavoriteStatus(item.timestamp);
                  _loadHistory();
                },
              ),
              onTap: () {
                // --- EKSİK KISIM DOLDURULDU ---
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(
                      imagePath: item.imagePath,
                      foodDataService: foodDataService,
                      historyItem: item,
                    ),
                  ),
                ).then((_) => _loadHistory());
              },
            ),
          ),
        ],
      ),
    );
  }
}
