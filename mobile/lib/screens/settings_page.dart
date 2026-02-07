import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Ayarlar"), // TODO: ARB'ye ekle -> l10n.settingsTitle
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // === Dil Seçimi Bölümü ===
          Text(
            l10n.languageSelection,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Uygulama dilini buradan değiştirebilirsiniz.", // TODO: ARB'ye ekle -> l10n.languageSelectionSubtitle
            style:
                theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildLanguageButton(
                  context: context,
                  provider: languageProvider,
                  locale: const Locale('tr'),
                  label: "Türkçe",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLanguageButton(
                  context: context,
                  provider: languageProvider,
                  locale: const Locale('en'),
                  label: "English",
                ),
              ),
            ],
          ),
          // Gelecekteki ayarlar için ayraç
          const Divider(height: 48),
        ],
      ),
    );
  }

  // Kod tekrarını önlemek için yardımcı widget
  Widget _buildLanguageButton({
    required BuildContext context,
    required LanguageProvider provider,
    required Locale locale,
    required String label,
  }) {
    final bool isSelected =
        provider.appLocale.languageCode == locale.languageCode;

    return ElevatedButton(
      onPressed: () {
        provider.changeLanguage(locale);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }
}
