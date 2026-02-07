// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CuisineScan';

  @override
  String get homeHeroTitle => 'Scan Your Food,\nTaste the World.';

  @override
  String get homeHeroSubtitle =>
      'Discover food and its culture from photos with AI.';

  @override
  String get homeStartScanning => 'Start Scanning';

  @override
  String get homeFeaturedTitle => 'Explore Featured Flavors';

  @override
  String get homeFeaturedSubtitle =>
      'Some of the popular dishes our application can recognize.';

  @override
  String get tabHome => 'Home';

  @override
  String get tabScan => 'Scan';

  @override
  String get tabHistory => 'History';

  @override
  String get tabProfile => 'Profile';

  @override
  String get selectionTitle => 'What would you like to scan?';

  @override
  String get selectionTurkishFood => 'Turkish Cuisine';

  @override
  String get selectionTurkishFoodSubtitle =>
      'Recognize traditional dishes and plates.';

  @override
  String get selectionFruitVeg => 'Fruit & Vegetable';

  @override
  String get selectionFruitVegSubtitle =>
      'Recognize a single fruit or vegetable.';

  @override
  String get scanTitleTurkish => 'Scan Turkish Cuisine';

  @override
  String get scanTitleFruitVeg => 'Scan Fruit & Veg';

  @override
  String get previewTitle => 'Preview';

  @override
  String get previewUseThisPhoto => 'Use This Photo';

  @override
  String get previewRetry => 'Retry';

  @override
  String get resultsTitle => 'Scan Result';

  @override
  String get resultsBestGuess => 'Best Guess';

  @override
  String resultsConfidence(String confidence) {
    return '$confidence% Confidence';
  }

  @override
  String get resultsDescription => 'Description';

  @override
  String get resultsHistory => 'History';

  @override
  String get resultsIngredients => 'Main Ingredients';

  @override
  String get resultsNutrition => 'Average Nutrition';

  @override
  String get resultsCalories => 'Estimated Calories';

  @override
  String resultsServing(String servingSize) {
    return 'for a portion of ~${servingSize}g';
  }

  @override
  String get resultsDetailsNotFound =>
      'Detailed information could not be found for this item.';

  @override
  String get small => 'Small';

  @override
  String get standard => 'Standard';

  @override
  String get large => 'Large';

  @override
  String get saveToHistoryButton => 'Save to History';

  @override
  String get languageSelection => 'Language Selection';

  @override
  String get profileInfoTitle => 'Profile Information';

  @override
  String get logoutButton => 'Log Out';

  @override
  String get logoutMessage => 'Logged out successfully!';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get historyEmptyTitle => 'No History Yet';

  @override
  String get historyEmptySubtitle =>
      'Your scanned items will appear here. Start scanning to build your collection!';

  @override
  String get tabExplore => 'Explore';

  @override
  String get explorePageTitle => 'Discover New Tastes';

  @override
  String get explorePageSubtitle => 'Discovery feature coming soon!';

  @override
  String get seeAll => 'See All';

  @override
  String get saveSuccessMessage => 'Successfully saved to history!';

  @override
  String get saveErrorMessage => 'Could not save to history. Please try again.';
}
