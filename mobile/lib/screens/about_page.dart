import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hakkımızda"), // TODO: ARB'ye ekle -> l10n.aboutTitle
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(height: 100);
              },
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'CuisineScan',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.displayMedium?.color,
            ),
          ),
          const SizedBox(height: 8),

          const Divider(height: 48),

          // --- YENİ, SADELEŞTİRİLMİŞ METİN ---
          const Text(
            'Dünya, tadılması gereken sonsuz bir lezzet haritasıdır. Her tabağın arkasında yüzyılların birikimi, bir kültürün hikayesi ve unutulmaz anılar yatar. Peki, hiç bilmediğiniz bir şehirde, önünüze gelen o gizemli yemeğin sırrını merak ettiniz mi?\n\nCuisineScan, işte bu merak anında sizin kişisel gastronomi rehberiniz olmak için doğdu. Biz, teknolojinin gücünü mutfak sanatıyla birleştirerek, gördüğünüz her tabağı anlamlı bir deneyime dönüştürmeyi hedefliyoruz. Amacımız sadece yemeklerin adını söylemek değil; onların ruhunu, kökenini ve ait oldukları kültürü parmaklarınızın ucuna getirmektir.\n\nBir fotoğraf karesiyle başlayan bu yolculuk, sizi Bursa\'nın tarihi sokaklarından Meksika\'nın renkli pazarlarına uzanan lezzetli bir maceraya çıkaracak.\n\nAfiyet olsun!',
            style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
