class HistoryItem {
  final String imagePath;
  final String predictionLabel;
  final double confidence;
  final DateTime timestamp;

  // FAZ 2'de ekleyeceğimiz favori özelliği için şimdiden yerini hazırlıyoruz.
  bool isFavorite;

  HistoryItem({
    required this.imagePath,
    required this.predictionLabel,
    required this.confidence,
    required this.timestamp,
    this.isFavorite = false, // Varsayılan olarak favori değil
  });

  // Bu metotlar, HistoryItem nesnesini kolayca JSON formatına (metne)
  // ve JSON formatından tekrar HistoryItem nesnesine çevirmemizi sağlar.
  // Bu, veriyi SharedPreferences'a kaydederken ve okurken hayati önem taşır.

  // HistoryItem nesnesini bir Map'e (JSON'a uygun) dönüştürür.
  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'predictionLabel': predictionLabel,
        'confidence': confidence,
        'timestamp':
            timestamp.toIso8601String(), // Tarihi standart bir formatta sakla
        'isFavorite': isFavorite,
      };

  // Bir Map'ten (JSON'dan) HistoryItem nesnesi oluşturur.
  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        imagePath: json['imagePath'],
        predictionLabel: json['predictionLabel'],
        confidence: json['confidence'],
        timestamp: DateTime.parse(json['timestamp']),
        // Eğer eski bir kayıtta isFavorite alanı yoksa, varsayılan olarak false ata.
        isFavorite: json['isFavorite'] ?? false,
      );
}
