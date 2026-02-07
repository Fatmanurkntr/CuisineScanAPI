import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';
import 'favorites_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabProfile),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- DİL SEÇİMİ BÖLÜMÜ KALDIRILDI ---

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.favorite_border),
            title: const Text("Favorilerim"),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
          ),
          const Divider(),

          // --- Yer tutucu profil bilgileri ---
          const SizedBox(height: 24),
          Text(
            l10n.profileInfoTitle,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.person_outline),
            title: Text("Kullanıcı Adı: John Doe"),
            subtitle: Text("Email: john.doe@example.com"),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.logoutButton,
                style: const TextStyle(color: Colors.red)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.logoutMessage)),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
