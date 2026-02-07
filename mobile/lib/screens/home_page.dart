import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/food_item.dart';
import '../services/food_data_service.dart';

// StatelessWidget'ı StatefulWidget'a çeviriyoruz
class HomePage extends StatefulWidget {
  final Function(int) onTabChange;

  const HomePage({
    super.key,
    required this.onTabChange,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Öne çıkan lezzetleri tutacak olan liste
  List<FoodItem> _featuredFoods = [];
  bool _isLoading = true; // Yüklenme durumunu takip etmek için

  @override
  void initState() {
    super.initState();
    // Widget ilk oluşturulduğunda verileri yükle
    _loadFeaturedFoods();
  }

  // Verileri FoodDataService'ten asenkron olarak çeken metot
  void _loadFeaturedFoods() {
    // Provider'a erişmek için context'i kullanıyoruz.
    // initState içinde context'i doğrudan kullanmak yerine bu güvenli bir yoldur.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // Widget ağaçtan kaldırıldıysa işlem yapma

      final foodDataService =
          Provider.of<FoodDataService>(context, listen: false);
      final languageCode = Localizations.localeOf(context).languageCode;

      // Öne çıkanlar için göstermek istediğimiz yemeklerin ID'leri
      const featuredFoodIds = ['iskender', 'lahmacun', 'icli-kofte'];

      final loadedFoods = <FoodItem>[];
      for (var id in featuredFoodIds) {
        final food =
            foodDataService.getFoodDetails(id, languageCode: languageCode);
        if (food != null) {
          loadedFoods.add(food);
        }
      }

      // State'i güncelleyerek arayüzün yeniden çizilmesini sağlıyoruz
      setState(() {
        _featuredFoods = loadedFoods;
        _isLoading = false; // Yükleme tamamlandı
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/arkaplan.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          // Karşılama bölümü
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      l10n.homeHeroTitle,
                      textAlign: TextAlign.center,
                      style: textTheme.displayMedium
                          ?.copyWith(fontSize: 42, height: 1.2),
                    ),
                  ),
                  const Spacer(flex: 3),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      l10n.homeHeroSubtitle,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                          fontSize: 17, color: const Color(0xFF4a4a4a)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black.withOpacity(0.4),
                    size: 32,
                  ),
                  const SizedBox(height: kBottomNavigationBarHeight + 20),
                ],
              ),
            ),
          ),

          // "Öne Çıkan Lezzetler" bölümü
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            l10n.homeFeaturedTitle,
                            style:
                                textTheme.displayMedium?.copyWith(fontSize: 26),
                          ),
                        ),
                        TextButton(
                          onPressed: () => widget.onTabChange(1),
                          child: Text(
                            l10n.seeAll,
                            style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      l10n.homeFeaturedSubtitle,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 240,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            itemCount: _featuredFoods.length,
                            itemBuilder: (context, index) {
                              final food = _featuredFoods[index];
                              return _buildFeaturedCard(food: food);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bu metot artık sabit değerler yerine bir 'FoodItem' objesi alıyor.
  Widget _buildFeaturedCard({required FoodItem food}) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 16.0),
      child: Card(
        color: Colors.white.withOpacity(0.95),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.15),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resmi artık dinamik olarak 'food.imageUrl'den alıyoruz
            Image.asset(
              food.imageUrl,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Eğer resim dosyası bulunamazsa bir hata ikonu göster
                return Container(
                  height: 130,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: Icon(Icons.image_not_supported_outlined,
                      color: Colors.grey[400]),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlığı ve açıklamayı da dinamik olarak 'food' objesinden alıyoruz
                  Text(
                    food.displayName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    food.description,
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey[800], height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
