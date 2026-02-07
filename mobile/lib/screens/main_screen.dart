import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_page.dart';
import 'model_selection_screen.dart';
import 'profile_page.dart';
import 'history_page.dart';
import 'explore_page.dart';
import 'settings_page.dart';
import 'about_page.dart';
import '../services/tensorflow_service.dart';
import '../services/food_data_service.dart';
import '../l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  // Widget'ları tutacak olan listemiz.
  // ModelSelectionScreen bu listede YOK.
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(onTabChange: _onItemTapped),
      const ExplorePage(),
      const HistoryPage(),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onScanButtonPressed() {
    final tensorflowService =
        Provider.of<TensorflowService>(context, listen: false);
    final foodDataService =
        Provider.of<FoodDataService>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModelSelectionScreen(
          // DOĞRU ÇAĞRI BURADA
          tensorflowService: tensorflowService,
          foodDataService: foodDataService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bool showAppBarIcons = _selectedIndex == 0;

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      appBar: showAppBarIcons
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black, size: 28),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.black, size: 28),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Bildirimler özelliği yakında gelecek!')),
                    );
                  },
                ),
              ],
            )
          : null,
      extendBodyBehindAppBar: true,
      drawer: _buildAppDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _onScanButtonPressed,
        backgroundColor: theme.colorScheme.primary,
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: const ImageIcon(AssetImage("assets/images/scan.png"),
            color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _pages[_selectedIndex],
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10.0,
            color: theme.scaffoldBackgroundColor.withOpacity(0.85),
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildNavItem(
                    theme: theme,
                    icon: Icons.home_filled,
                    label: l10n.tabHome,
                    index: 0),
                _buildNavItem(
                    theme: theme,
                    icon: Icons.explore_outlined,
                    label: l10n.tabExplore,
                    index: 1),
                const SizedBox(width: 40),
                _buildNavItem(
                    theme: theme,
                    icon: Icons.bookmark_border,
                    label: l10n.tabHistory,
                    index: 2),
                _buildNavItem(
                    theme: theme,
                    icon: Icons.person_outline,
                    label: l10n.tabProfile,
                    index: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: const Text('CuisineScan',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Ayarlar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Hakkımızda'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('Geri Bildirim Gönder'),
            onTap: () async {
              Navigator.pop(context);
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path:
                    'senin-mailin@example.com', // BURAYI KENDİ MAİLİNLE DEĞİŞTİR
                query: 'subject=CuisineScan Geri Bildirim',
              );
              try {
                await launchUrl(emailLaunchUri);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('E-posta uygulaması bulunamadı.')));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? theme.colorScheme.primary : Colors.grey[800];
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.2),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
