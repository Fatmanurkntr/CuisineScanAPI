// lib/services/tensorflow_service.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image/image.dart' as img;

// Hangi modelin aktif olduğunu takip etmek için bir enum (sınıflandırma) oluşturuyoruz.
// Bu, kodumuzu çok daha okunabilir ve hatasız hale getirir.
enum ModelType { turkishCuisine, fruitAndVeg }

class TensorflowService {
  // Varsayılan olarak Türk Mutfağı modeli ile başlar.
  ModelType _activeModel = ModelType.turkishCuisine;

  // Dışarıdan aktif modeli öğrenmek için bir getter.
  ModelType get activeModel => _activeModel;

  // Bu fonksiyon artık hangi modeli yükleyeceğini bir parametre olarak alıyor.
  Future<String?> loadModel(
      {ModelType modelType = ModelType.turkishCuisine}) async {
    Tflite.close(); // Önceki modelleri temizle
    try {
      String modelPath;
      String labelsPath;

      // Gelen parametreye göre doğru model ve etiket dosyalarını seç.
      if (modelType == ModelType.turkishCuisine) {
        modelPath = "assets/turk_mutfagi_model_mobil.tflite";
        labelsPath = "assets/turk_mutfagi_labels.txt";
      } else {
        modelPath = "assets/meyve_sebze_model_mobil.tflite";
        labelsPath = "assets/meyve_sebze_labels.txt";
      }

      String? res = await Tflite.loadModel(
        model: modelPath,
        labels: labelsPath,
        isAsset: true,
      );

      // Aktif modeli güncelle.
      _activeModel = modelType;
      print(
          "TensorflowService: '${_activeModel.name}' modeli başarıyla yüklendi -> $res");
      return res;
    } catch (e) {
      print("Model yüklenirken HATA oluştu: $e");
      return "Hata: $e";
    }
  }

  // Bu fonksiyon değişmedi, çünkü her iki model de aynı ön işlemeyi kullanıyor.
  Future<List<Map<String, dynamic>>> classifyImage(File imageFile) async {
    // Adım 1: Resmi diskten oku.
    Uint8List imageBytes = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) return [];

    // Adım 2: Resmi Python'daki gibi 'linear' (Bilinear) ile yeniden boyutlandır.
    img.Image resizedImage = img.copyResize(
      originalImage,
      width: 224,
      height: 224,
      interpolation: img.Interpolation.linear,
    );

    // Adım 3: Pikselleri Float32List'e dönüştür. NORMALİZASYON YOK!
    var buffer = Float32List(1 * 224 * 224 * 3);
    var pixelIndex = 0;
    for (var y = 0; y < 224; y++) {
      for (var x = 0; x < 224; x++) {
        var pixel = resizedImage.getPixel(x, y);
        // Modele, eğitimde olduğu gibi, ham 0-255 piksel değerlerini veriyoruz.
        buffer[pixelIndex++] = img.getRed(pixel).toDouble();
        buffer[pixelIndex++] = img.getGreen(pixel).toDouble();
        buffer[pixelIndex++] = img.getBlue(pixel).toDouble();
      }
    }

    // Adım 4: İşlenmiş ham veriyi doğrudan modele ver.
    var recognitions = await Tflite.runModelOnBinary(
      binary: buffer.buffer.asUint8List(),
      numResults: 10,
      threshold: 0.01,
    );

    print("TAHMİN (${_activeModel.name}): $recognitions");

    if (recognitions == null) return [];
    return recognitions
        .map((rec) => {"label": rec["label"], "confidence": rec["confidence"]})
        .toList();
  }

  void dispose() {
    Tflite.close();
  }
}
