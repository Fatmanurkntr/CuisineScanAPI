import 'dart:io';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class PreviewScreen extends StatelessWidget {
  final String imagePath;

  const PreviewScreen({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(l10n.previewTitle),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              // --- DEĞİŞİKLİK BURADA: Hero widget'ı ekliyoruz ---
              child: Hero(
                tag: imagePath, // Bu tag, ResultScreen'deki tag ile eşleşmeli
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: Text(l10n.previewRetry,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(imagePath);
                  },
                  icon: const Icon(Icons.check_circle_outline,
                      color: Colors.white),
                  label: Text(l10n.previewUseThisPhoto,
                      style: theme.textTheme.labelLarge),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
