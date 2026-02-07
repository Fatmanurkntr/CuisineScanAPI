import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Servisler
import 'services/tensorflow_service.dart';
import 'services/food_data_service.dart';
import 'services/history_service.dart'; // HistoryService'i import et
import 'services/recommendation_service.dart'; // RecommendationService'i import et

// Ekranlar
import 'screens/main_screen.dart';

// Dil Yönetimi (l10n)
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

// Durum Yönetimi (State Management)
import 'providers/language_provider.dart';

// main fonksiyonunu 'async' olarak işaretliyoruz çünkü içinde 'await' kullanacağız.
void main() async {
  // Flutter'ın başlatılması için bu komut her zaman en başta olmalı.
  WidgetsFlutterBinding.ensureInitialized();

  // --- SERVİSLERİ OLUŞTURMA ---
  // Tüm servislerimizi ve provider'larımızı tek bir yerde oluşturuyoruz.
  final tensorflowService = TensorflowService();
  final foodDataService = FoodDataService();
  final languageProvider = LanguageProvider();
  final historyService = HistoryService();

  // RecommendationService, diğer iki servise bağımlı olduğu için
  // onları parametre olarak alarak oluşturuluyor.
  final recommendationService = RecommendationService(
    foodDataService: foodDataService,
    historyService: historyService,
  );

  // --- VERİLERİ ÖNCEDEN YÜKLEME ---
  // Uygulama başlamadan önce, gerekli verilerin yüklenmesini sağlıyoruz.
  tensorflowService
      .loadModel(); // Bu beklemek zorunda değil, arka planda yüklenebilir.

  // Öneri sisteminin doğru çalışması için yemek verilerinin yüklenmesini
  // beklemek ZORUNDAYIZ. Bu yüzden 'await' kullanıyoruz.
  await foodDataService.loadAllData();

  runApp(
    // MultiProvider, tüm servislerimizi uygulama ağacının en tepesine koyar.
    // Bu sayede, uygulamanın herhangi bir yerinden onlara erişebiliriz.
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageProvider),
        Provider.value(value: tensorflowService),
        Provider.value(value: foodDataService),
        Provider.value(
            value: historyService), // HistoryService'i provider listesine ekle
        Provider.value(
            value:
                recommendationService), // RecommendationService'i provider listesine ekle
      ],
      child: const CuisineScanApp(),
    ),
  );
}

class CuisineScanApp extends StatelessWidget {
  const CuisineScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer widget'ı, LanguageProvider'ı dinler.
    // Dil değiştiğinde (notifyListeners çağrıldığında), bu builder metodu
    // yeniden çalışır ve MaterialApp'i yeni dille yeniden çizer.
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          // Dili artık cihazdan değil, LanguageProvider'dan alıyoruz.
          locale: languageProvider.appLocale,

          // l10n kurulumu
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF4a5c48)),
            useMaterial3: true,
            textTheme: TextTheme(
              displayMedium: GoogleFonts.playfairDisplay(
                  color: const Color(0xFF3a3a3a), fontWeight: FontWeight.bold),
              bodyMedium: GoogleFonts.poppins(color: const Color(0xFF3a3a3a)),
              labelLarge: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
          ),
          // Ana ekranımız MainScreen, ihtiyacı olan servisleri Provider'dan kendisi alacak.
          home: const MainScreen(),
        );
      },
    );
  }
}
