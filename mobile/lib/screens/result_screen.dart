import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import '../models/food_item.dart';
import '../models/history_item.dart';
import '../services/food_data_service.dart';
import '../services/history_service.dart';
import '../l10n/app_localizations.dart';

enum PortionSize { small, standard, large }

class ResultScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? predictions;
  final HistoryItem? historyItem;
  final String imagePath;
  final FoodDataService foodDataService;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.foodDataService,
    this.predictions,
    this.historyItem,
  }) : assert(predictions != null || historyItem != null,
            'predictions veya historyItem\'dan biri mutlaka sağlanmalı');

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String topPredictionId;
  late double topConfidence;
  late DateTime timestamp;
  FoodItem? foodDetails;
  PortionSize _selectedPortion = PortionSize.standard;
  bool _isDataProcessed = false;
  bool _hasBeenSaved = false;
  bool _isFavorite = false;
  final HistoryService _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    if (widget.predictions != null && widget.predictions!.isNotEmpty) {
      final topPrediction = widget.predictions!.first;
      topPredictionId = topPrediction['label'];
      topConfidence = topPrediction['confidence'];
      timestamp = DateTime.now();
      _isFavorite = false;
    } else if (widget.historyItem != null) {
      topPredictionId = widget.historyItem!.predictionLabel;
      topConfidence = widget.historyItem!.confidence;
      timestamp = widget.historyItem!.timestamp;
      _isFavorite = widget.historyItem!.isFavorite;
      _hasBeenSaved = true;
    } else {
      topPredictionId = "unknown";
      topConfidence = 0.0;
      timestamp = DateTime.now();
    }
  }

  void _toggleFavorite() async {
    await _historyService.toggleFavoriteStatus(timestamp);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _shareResult() async {
    final l10n = AppLocalizations.of(context)!;
    final shareText =
        "'${foodDetails?.displayName ?? l10n.resultsBestGuess}' CuisineScan ile keşfettim!";
    await Share.shareXFiles([XFile(widget.imagePath)],
        text: shareText, subject: l10n.appTitle);
  }

  void _autoSaveToHistory() async {
    if (_hasBeenSaved) return;
    final newItem = HistoryItem(
        imagePath: widget.imagePath,
        predictionLabel: topPredictionId,
        confidence: topConfidence,
        timestamp: timestamp);
    try {
      await _historyService.addToHistory(newItem);
      if (mounted) {
        setState(() {
          _hasBeenSaved = true;
        });
      }
    } catch (e) {
      print("Otomatik kaydetme sırasında hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDataProcessed) {
      final languageCode = Localizations.localeOf(context).languageCode;
      foodDetails = widget.foodDataService
          .getFoodDetails(topPredictionId, languageCode: languageCode);
      _isDataProcessed = true;
      if (topPredictionId != "unknown" && widget.historyItem == null) {
        _autoSaveToHistory();
      }
    }
    final l10n = AppLocalizations.of(context)!;
    final formattedLabel =
        foodDetails?.displayName ?? _formatLabel(topPredictionId);
    final confidencePercentage = (topConfidence * 100).toStringAsFixed(1);
    const cardBackgroundColor = Color(0xFFF8F7F5);
    const primaryTextColor = Color(0xFF3a3a3a);
    const secondaryTextColor = Color(0xFF6c757d);
    const confidenceBadgeColor = Color(0xFF198754);
    const caloriesBadgeColor = Color(0xFFffc107);

    // YENİ: Hero animasyonunu sadece yeni bir taramadan geliyorsak kullan.
    final bool useHeroAnimation = widget.predictions != null;

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.resultsTitle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryTextColor,
        actions: [
          IconButton(
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
              color: _isFavorite ? Colors.redAccent : null,
              tooltip: "Favorilere Ekle",
              onPressed: _toggleFavorite),
          IconButton(
              icon: const Icon(Icons.share_outlined), onPressed: _shareResult),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
        children: [
          Card(
            color: Colors.white,
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.05),
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- NİHAİ DÜZELTME BURADA: Hero widget'ını koşullu yapıyoruz ---
                useHeroAnimation
                    ? Hero(
                        tag: widget.imagePath,
                        child: _buildImageWidget(),
                      )
                    : _buildImageWidget(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              formattedLabel,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: confidenceBadgeColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              l10n.resultsConfidence(confidencePercentage),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (foodDetails != null &&
                          foodDetails!.description.isNotEmpty)
                        Text(
                          foodDetails!.description,
                          style: TextStyle(
                              fontSize: 15,
                              color: secondaryTextColor,
                              height: 1.5),
                        ),
                      const Divider(height: 32, thickness: 0.5),
                      if (foodDetails != null &&
                          foodDetails!.history.isNotEmpty) ...[
                        _buildInfoRow(
                          icon: Icons.history_edu_outlined,
                          title: l10n.resultsHistory,
                          content: foodDetails!.history,
                          textColor: primaryTextColor,
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (foodDetails != null &&
                          foodDetails!.mainIngredients.isNotEmpty) ...[
                        _buildInfoRow(
                          icon: Icons.egg_alt_outlined,
                          title: l10n.resultsIngredients,
                          content: foodDetails!.mainIngredients.join(', '),
                          textColor: primaryTextColor,
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (foodDetails?.nutritionInfo != null)
                        _buildNutritionSection(
                            l10n,
                            foodDetails!.nutritionInfo!,
                            primaryTextColor,
                            secondaryTextColor,
                            caloriesBadgeColor),
                      if (foodDetails == null && topPredictionId != "unknown")
                        Text(l10n.resultsDetailsNotFound,
                            style: TextStyle(color: Colors.red)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    // Gelen resim yolu bir "asset" mi? ('assets/' ile mi başlıyor?)
    final bool isAsset = widget.imagePath.startsWith('assets/');

    if (isAsset) {
      // EVET, ASSET İSE: "Kitap sayfası" komutunu kullan.
      return Image.asset(
        widget.imagePath,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage();
        },
      );
    } else {
      // HAYIR, ASSET DEĞİLSE (yani kameradan/galeriden gelen dosya ise):
      // "Ev adresi" komutunu kullan.
      return Image.file(
        File(widget.imagePath),
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage();
        },
      );
    }
  }

// Hata durumunda gösterilecek ortak widget
  Widget _buildErrorImage() {
    return Container(
      height: 220,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child:
          const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 50),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String content,
    required Color textColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: textColor.withOpacity(0.7), size: 22),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    height: 1.5,
                    fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionSection(AppLocalizations l10n, NutritionInfo nutrition,
      Color primaryTextColor, Color secondaryTextColor, Color badgeColor) {
    double multiplier = 1.0;
    if (_selectedPortion == PortionSize.small) multiplier = 0.7;
    if (_selectedPortion == PortionSize.large) multiplier = 1.3;

    final estimatedCalories = (nutrition.caloriesPer100g *
            nutrition.defaultServingSizeG *
            multiplier) /
        100;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.local_fire_department_outlined,
                color: primaryTextColor.withOpacity(0.7), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.resultsNutrition,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryTextColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.resultsServing(
                        nutrition.defaultServingSizeG.toString()),
                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "~${estimatedCalories.round()} kcal",
                style: TextStyle(
                    color: primaryTextColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ToggleButtons(
          isSelected: [
            _selectedPortion == PortionSize.small,
            _selectedPortion == PortionSize.standard,
            _selectedPortion == PortionSize.large,
          ],
          onPressed: (index) {
            setState(() {
              _selectedPortion = PortionSize.values[index];
            });
          },
          // === YENİ TOGGLEBUTTONS STİLİ ===
          color: primaryTextColor, // Seçili olmayan butonun metin rengi
          selectedColor: Colors.white, // Seçili butonun metin rengi
          fillColor: primaryTextColor, // Seçili butonun dolgu rengi
          splashColor: primaryTextColor.withOpacity(0.12),
          hoverColor: primaryTextColor.withOpacity(0.04),
          borderColor: Colors.grey[300],
          selectedBorderColor: primaryTextColor,
          borderRadius: BorderRadius.circular(8),
          constraints: BoxConstraints(
              minWidth: (MediaQuery.of(context).size.width - 100) / 3,
              minHeight: 45),
          children: [Text(l10n.small), Text(l10n.standard), Text(l10n.large)],
        )
      ],
    );
  }

  String _formatLabel(String label) {
    if (label == "unknown") return "Bulunamadı";
    return label
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
