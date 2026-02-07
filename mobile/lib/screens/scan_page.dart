// lib/screens/scan_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'preview_screen.dart';
import '../services/tensorflow_service.dart';
import '../services/food_data_service.dart';
import 'result_screen.dart';
import '../l10n/app_localizations.dart'; // <-- Tercümanı kullanacağımız için import ettik

class ScanPage extends StatefulWidget {
  final TensorflowService tensorflowService;
  final FoodDataService foodDataService;

  const ScanPage({
    super.key,
    required this.tensorflowService,
    required this.foodDataService,
  });

  @override
  State<ScanPage> createState() => ScanPageState();
}

class ScanPageState extends State<ScanPage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Bu ekrana artık sadece model seçildikten sonra gelindiği için,
    // kamera hemen başlatılabilir.
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Uygulama arka plana atıldığında kamerayı kapat, geri geldiğinde aç.
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera(cameraIndex: _selectedCameraIndex);
    }
  }

  Future<void> _initializeCamera({int cameraIndex = 0}) async {
    try {
      if (_cameras.isEmpty) _cameras = await availableCameras();
      if (_cameras.isEmpty) throw ("Kamera bulunamadı");
      if (cameraIndex >= _cameras.length) cameraIndex = 0;

      final newController = CameraController(
          _cameras[cameraIndex], ResolutionPreset.high,
          enableAudio: false);
      await _controller?.dispose(); // Önceki kontrolcüyü kapat
      await newController.initialize(); // Yeni kontrolcüyü başlat

      if (mounted) {
        setState(() {
          _controller = newController;
          _selectedCameraIndex = cameraIndex;
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        print("Kamera başlatılamadı: $e");
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (image != null && mounted) _navigateToPreviewAndPredict(image.path);
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      await _controller!
          .pausePreview(); // Fotoğraf çekmeden önce önizlemeyi duraklat
      final image = await _controller!.takePicture();
      if (mounted)
        await _controller!
            .resumePreview(); // Çektikten sonra önizlemeyi devam ettir
      if (mounted) _navigateToPreviewAndPredict(image.path);
    } catch (e) {
      print("Fotoğraf çekilirken hata: $e");
    }
  }

  void _flipCamera() {
    if (_cameras.length > 1) {
      // Kamerayı durdur ve yeni kamerayı başlat
      _controller?.dispose(); // Kamerayı geçici olarak kapat
      final newIndex = (_selectedCameraIndex + 1) % _cameras.length;
      _initializeCamera(cameraIndex: newIndex); // Yeni kamerayı başlat
    }
  }

  void _navigateToPreviewAndPredict(String imagePath) async {
    _controller?.dispose();
    _controller = null;
    _isCameraInitialized = false;

    // --- DEĞİŞİKLİK BURADA: Navigator.push'ı güncelliyoruz ---
    // Artık PreviewScreen'in kendisi Hero içerdiği için dıştan sarmalamaya gerek yok.
    final confirmedImagePath = await Navigator.of(context).push<String>(
      MaterialPageRoute(
          builder: (context) => PreviewScreen(imagePath: imagePath)),
    );

    if (confirmedImagePath == null || !mounted) {
      _initializeCamera(cameraIndex: _selectedCameraIndex);
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      final File imageFile = File(confirmedImagePath);
      final predictions =
          await widget.tensorflowService.classifyImage(imageFile);

      if (!mounted) return;
      Navigator.of(context).pop();

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            foodDataService: widget.foodDataService,
            imagePath: confirmedImagePath,
            predictions: predictions, // 'predictions' ile çağırıyoruz
          ),
        ),
      );
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      print("Tahmin sırasında hata: $e");
    } finally {
      if (mounted) _initializeCamera(cameraIndex: _selectedCameraIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tercümanı çağırıyoruz.
    final l10n = AppLocalizations.of(context)!;

    // Kamera yükleniyorken veya başlatılamıyorsa bir yüklenme ekranı göster.
    if (!_isCameraInitialized ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black, // Yükleme ekranı da siyah olsun
        appBar: AppBar(
          title: Text(
            widget.tensorflowService.activeModel == ModelType.turkishCuisine
                ? l10n.scanTitleTurkish
                : l10n.scanTitleFruitVeg,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body:
            const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor:
          Colors.black, // Arka planı siyah tutuyoruz, bu odaklanmayı artırır.
      body: Stack(
        children: [
          // Kamera önizlemesi ekranı tamamen kaplayacak
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),

          // Yarı şeffaf kaplama (Overlay) ve tarama çerçevesi
          _buildScannerOverlay(context),

          // AppBar'ı en üste, her şeyin üzerine koyuyoruz
          _buildAppBar(context),

          // Kontrol panelini en alta, her şeyin üzerine koyuyoruz
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    // Tercümanı çağırıyoruz.
    final l10n = AppLocalizations.of(context)!;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        title: Text(
          widget.tensorflowService.activeModel == ModelType.turkishCuisine
              ? l10n.scanTitleTurkish
              : l10n.scanTitleFruitVeg,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }

  Widget _buildScannerOverlay(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanSize = size.width * 0.7;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.6), // Arka planı karart
        BlendMode.srcOut, // Ortadaki boşluğu açan sihirli mod
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors
                  .transparent, // Bu, ColorFiltered'ın çalışması için gerekli
            ),
          ),
          // Ortadaki şeffaf kare alan
          Align(
            alignment: Alignment.center,
            child: Container(
              height: scanSize,
              width: scanSize,
              decoration: BoxDecoration(
                color: Colors.black, // Bu renk, srcOut ile transparan olacak
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      color: Colors
          .transparent, // Arka planı şeffaf yapıyoruz çünkü overlay zaten karartıyor
      padding:
          const EdgeInsets.fromLTRB(24, 24, 24, 48), // Alt boşluğu artırdık
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: const Icon(Icons.photo_library_outlined,
                  color: Colors.white, size: 30),
              onPressed: _pickImageFromGallery),
          GestureDetector(
            onTap: _takePicture,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2)),
                ),
              ),
            ),
          ),
          IconButton(
              icon: const Icon(Icons.flip_camera_ios_outlined,
                  color: Colors.white, size: 30),
              onPressed: _cameras.length > 1 ? _flipCamera : null),
        ],
      ),
    );
  }
}
