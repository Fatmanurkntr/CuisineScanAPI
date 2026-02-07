import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CuisineScan'**
  String get appTitle;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Your Food,\nTaste the World.'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover food and its culture from photos with AI.'**
  String get homeHeroSubtitle;

  /// No description provided for @homeStartScanning.
  ///
  /// In en, this message translates to:
  /// **'Start Scanning'**
  String get homeStartScanning;

  /// No description provided for @homeFeaturedTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Featured Flavors'**
  String get homeFeaturedTitle;

  /// No description provided for @homeFeaturedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Some of the popular dishes our application can recognize.'**
  String get homeFeaturedSubtitle;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get tabScan;

  /// No description provided for @tabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabHistory;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @selectionTitle.
  ///
  /// In en, this message translates to:
  /// **'What would you like to scan?'**
  String get selectionTitle;

  /// No description provided for @selectionTurkishFood.
  ///
  /// In en, this message translates to:
  /// **'Turkish Cuisine'**
  String get selectionTurkishFood;

  /// No description provided for @selectionTurkishFoodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recognize traditional dishes and plates.'**
  String get selectionTurkishFoodSubtitle;

  /// No description provided for @selectionFruitVeg.
  ///
  /// In en, this message translates to:
  /// **'Fruit & Vegetable'**
  String get selectionFruitVeg;

  /// No description provided for @selectionFruitVegSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recognize a single fruit or vegetable.'**
  String get selectionFruitVegSubtitle;

  /// No description provided for @scanTitleTurkish.
  ///
  /// In en, this message translates to:
  /// **'Scan Turkish Cuisine'**
  String get scanTitleTurkish;

  /// No description provided for @scanTitleFruitVeg.
  ///
  /// In en, this message translates to:
  /// **'Scan Fruit & Veg'**
  String get scanTitleFruitVeg;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewTitle;

  /// No description provided for @previewUseThisPhoto.
  ///
  /// In en, this message translates to:
  /// **'Use This Photo'**
  String get previewUseThisPhoto;

  /// No description provided for @previewRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get previewRetry;

  /// No description provided for @resultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get resultsTitle;

  /// No description provided for @resultsBestGuess.
  ///
  /// In en, this message translates to:
  /// **'Best Guess'**
  String get resultsBestGuess;

  /// Confidence percentage for the prediction.
  ///
  /// In en, this message translates to:
  /// **'{confidence}% Confidence'**
  String resultsConfidence(String confidence);

  /// No description provided for @resultsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get resultsDescription;

  /// No description provided for @resultsHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get resultsHistory;

  /// No description provided for @resultsIngredients.
  ///
  /// In en, this message translates to:
  /// **'Main Ingredients'**
  String get resultsIngredients;

  /// No description provided for @resultsNutrition.
  ///
  /// In en, this message translates to:
  /// **'Average Nutrition'**
  String get resultsNutrition;

  /// No description provided for @resultsCalories.
  ///
  /// In en, this message translates to:
  /// **'Estimated Calories'**
  String get resultsCalories;

  /// Text describing the serving size for nutrition info.
  ///
  /// In en, this message translates to:
  /// **'for a portion of ~{servingSize}g'**
  String resultsServing(String servingSize);

  /// No description provided for @resultsDetailsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Detailed information could not be found for this item.'**
  String get resultsDetailsNotFound;

  /// No description provided for @small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @saveToHistoryButton.
  ///
  /// In en, this message translates to:
  /// **'Save to History'**
  String get saveToHistoryButton;

  /// No description provided for @languageSelection.
  ///
  /// In en, this message translates to:
  /// **'Language Selection'**
  String get languageSelection;

  /// No description provided for @profileInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profileInfoTitle;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutButton;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully!'**
  String get logoutMessage;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No History Yet'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your scanned items will appear here. Start scanning to build your collection!'**
  String get historyEmptySubtitle;

  /// No description provided for @tabExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get tabExplore;

  /// No description provided for @explorePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover New Tastes'**
  String get explorePageTitle;

  /// No description provided for @explorePageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discovery feature coming soon!'**
  String get explorePageSubtitle;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @saveSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Successfully saved to history!'**
  String get saveSuccessMessage;

  /// No description provided for @saveErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not save to history. Please try again.'**
  String get saveErrorMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
