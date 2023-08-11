import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_es.dart';

class L10n {
  // Store the instances of AppLocalizations
  static final _localizedValues = {
    'en': AppLocalizationsEn(),
    'es': AppLocalizationsEs(),
    // Add more supported locales here as needed
  };

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static List<Locale> get all => _localizedValues.values
      .map((localization) => Locale(localization.localeName))
      .toList();

  static String getFlag(String code) {
    switch (code) {
      case 'en':
        return '🇺🇸';
      case 'es':
        return '🇪🇸';
      default:
        return '🏳️';
    }
  }

  // Get the AppLocalizations instance based on the locale code
  static AppLocalizations? getLocaleInstance(String localeCode) {
    return _localizedValues[localeCode];
  }
}
