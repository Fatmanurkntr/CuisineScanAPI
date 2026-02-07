// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'CuisineScan';

  @override
  String get homeHeroTitle => 'Yemeğini Tanı,\nDünyayı Tat.';

  @override
  String get homeHeroSubtitle =>
      'Yapay zeka ile fotoğraftan yemekleri ve kültürlerini keşfet.';

  @override
  String get homeStartScanning => 'Taramayı Başlat';

  @override
  String get homeFeaturedTitle => 'Öne Çıkan Lezzetleri Keşfet';

  @override
  String get homeFeaturedSubtitle =>
      'Uygulamamızın tanıyabildiği popüler yemeklerden bazıları.';

  @override
  String get tabHome => 'Ana Sayfa';

  @override
  String get tabScan => 'Tara';

  @override
  String get tabHistory => 'Geçmiş';

  @override
  String get tabProfile => 'Profil';

  @override
  String get selectionTitle => 'Ne Taramak İstersiniz?';

  @override
  String get selectionTurkishFood => 'Türk Mutfağı';

  @override
  String get selectionTurkishFoodSubtitle =>
      'Geleneksel yemekleri ve tabakları tanıyın.';

  @override
  String get selectionFruitVeg => 'Meyve & Sebze';

  @override
  String get selectionFruitVegSubtitle => 'Tek bir meyve veya sebzeyi tanıyın.';

  @override
  String get scanTitleTurkish => 'Türk Mutfağı Tara';

  @override
  String get scanTitleFruitVeg => 'Meyve & Sebze Tara';

  @override
  String get previewTitle => 'Önizleme';

  @override
  String get previewUseThisPhoto => 'Bu Fotoğrafı Kullan';

  @override
  String get previewRetry => 'Yeniden';

  @override
  String get resultsTitle => 'Tarama Sonucu';

  @override
  String get resultsBestGuess => 'En İyi Tahmin';

  @override
  String resultsConfidence(String confidence) {
    return '%$confidence Güven Oranı';
  }

  @override
  String get resultsDescription => 'Açıklama';

  @override
  String get resultsHistory => 'Tarihçe';

  @override
  String get resultsIngredients => 'Ana Malzemeler';

  @override
  String get resultsNutrition => 'Ortalama Besin Değeri';

  @override
  String get resultsCalories => 'Tahmini Kalori';

  @override
  String resultsServing(String servingSize) {
    return 'yaklaşık ${servingSize}g porsiyon için';
  }

  @override
  String get resultsDetailsNotFound =>
      'Bu yiyecek için detaylı bilgi bulunamadı.';

  @override
  String get small => 'Küçük';

  @override
  String get standard => 'Standart';

  @override
  String get large => 'Büyük';

  @override
  String get saveToHistoryButton => 'Geçmişe Kaydet';

  @override
  String get languageSelection => 'Dil Seçimi';

  @override
  String get profileInfoTitle => 'Profil Bilgileri';

  @override
  String get logoutButton => 'Çıkış Yap';

  @override
  String get logoutMessage => 'Başarıyla çıkış yapıldı!';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get historyEmptyTitle => 'Henüz Geçmiş Yok';

  @override
  String get historyEmptySubtitle =>
      'Taradığınız öğeler burada görünecek. Koleksiyonunuzu oluşturmak için taramaya başlayın!';

  @override
  String get tabExplore => 'Keşfet';

  @override
  String get explorePageTitle => 'Yeni Lezzetler Keşfet';

  @override
  String get explorePageSubtitle => 'Keşfet özelliği yakında gelecek!';

  @override
  String get seeAll => 'Tümünü Gör';

  @override
  String get saveSuccessMessage => 'Geçmişe başarıyla kaydedildi!';

  @override
  String get saveErrorMessage =>
      'Geçmişe kaydedilemedi. Lütfen tekrar deneyin.';
}
