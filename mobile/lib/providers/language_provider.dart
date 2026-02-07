import 'package:flutter/material.dart';

// ChangeNotifier, "Durumum değişti, beni dinleyen herkes kendini güncellesin!"
// dememizi sağlayan sihirli bir Flutter sınıfıdır.
class LanguageProvider with ChangeNotifier {
  // Varsayılan dilimizi Türkçe olarak başlatıyoruz.
  // Uygulama açıldığında bu değer kullanılacak.
  Locale _appLocale = const Locale('tr');

  // Dışarıdan, o anki dilin ne olduğunu öğrenmek için bir "getter"
  Locale get appLocale => _appLocale;

  // Kullanıcı yeni bir dil seçtiğinde bu fonksiyonu çağıracağız.
  void changeLanguage(Locale newLocale) {
    // Eğer zaten seçili olan dil seçilirse, hiçbir şey yapma.
    if (_appLocale == newLocale) return;

    // Dili güncelle.
    _appLocale = newLocale;

    // EN ÖNEMLİ KISIM:
    // "Hey! Benim durumum (dilim) değişti!" diye herkese haber ver.
    // Bu komut, bizi dinleyen tüm widget'ların yeniden çizilmesini tetikler.
    notifyListeners();
    print("Uygulama dili şuna değiştirildi: ${_appLocale.languageCode}");
  }
}
