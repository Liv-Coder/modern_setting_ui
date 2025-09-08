import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Localization delegate for Modern Settings UI.
class ModernSettingsUILocalizations {
  static const LocalizationsDelegate<ModernSettingsUILocalizations> delegate =
      _ModernSettingsUILocalizationsDelegate();

  static ModernSettingsUILocalizations of(BuildContext context) {
    return Localizations.of<ModernSettingsUILocalizations>(
      context,
      ModernSettingsUILocalizations,
    )!;
  }

  // Add localized strings here
  String get settings => Intl.message(
        'Settings',
        name: 'settings',
        desc: 'Title for settings screen',
      );

  String get general => Intl.message(
        'General',
        name: 'general',
        desc: 'General settings section',
      );

  String get darkMode => Intl.message(
        'Dark Mode',
        name: 'darkMode',
        desc: 'Dark mode toggle label',
      );

  String get language => Intl.message(
        'Language',
        name: 'language',
        desc: 'Language selection label',
      );
}

class _ModernSettingsUILocalizationsDelegate
    extends LocalizationsDelegate<ModernSettingsUILocalizations> {
  const _ModernSettingsUILocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  Future<ModernSettingsUILocalizations> load(Locale locale) async {
    // In a real implementation, you would load translations from files
    // For now, return the default instance
    return ModernSettingsUILocalizations();
  }

  @override
  bool shouldReload(_ModernSettingsUILocalizationsDelegate old) => false;
}
