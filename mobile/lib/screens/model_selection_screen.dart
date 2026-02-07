import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Bu import'a ihtiyacınız olmayabilir, Provider kullanmıyorsanız silebilirsiniz.
import '../services/tensorflow_service.dart';
import '../services/food_data_service.dart';
import 'scan_page.dart';
import '../l10n/app_localizations.dart';
import 'dart:ui';

class ModelSelectionScreen extends StatelessWidget {
  final TensorflowService tensorflowService;
  final FoodDataService foodDataService;

  const ModelSelectionScreen({
    super.key,
    required this.tensorflowService,
    required this.foodDataService,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context); // 'theme' burada tanımlanıyor

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectionTitle),
        // 1. Arka plan rengini, bulanıklığın görünebilmesi için yarı şeffaf yapıyoruz.
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black87,
        // 2. flexibleSpace kullanarak AppBar'ın arkasına bir bulanıklık filtresi ekliyoruz.
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors
                  .transparent, // Bu container sadece filtrenin alanını belirler
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/foto5.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSelectionCard(
                  context: context,
                  title: l10n.selectionTurkishFood,
                  subtitle: l10n.selectionTurkishFoodSubtitle,
                  iconData: Icons.restaurant_menu_outlined,
                  onTap: () =>
                      _navigateToScanPage(context, ModelType.turkishCuisine),
                ),
                const SizedBox(height: 24),
                _buildSelectionCard(
                  context: context,
                  title: l10n.selectionFruitVeg,
                  subtitle: l10n.selectionFruitVegSubtitle,
                  iconData: Icons.grass_outlined,
                  onTap: () =>
                      _navigateToScanPage(context, ModelType.fruitAndVeg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // DÜZELTİLMİŞ METOT
  void _navigateToScanPage(BuildContext context, ModelType modelType) async {
    _showLoadingDialog(context);

    print("${modelType.name} modeli seçildi. Yükleniyor...");
    await tensorflowService.loadModel(modelType: modelType);

    if (context.mounted) {
      Navigator.of(context).pop(); // Loading dialog'unu kapat
      Navigator.push(
        context,
        MaterialPageRoute(
          // ScanPage'e ihtiyaç duyduğu servisleri gönderiyoruz.
          builder: (context) => ScanPage(
            tensorflowService: tensorflowService,
            foodDataService: foodDataService,
          ),
        ),
      );
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSelectionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 6.0,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(iconData,
                  size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
