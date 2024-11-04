import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Messages extends LocalizationsDelegate<Messages> {
  // static const String _locale = 'es';

  // Data structure for translations
  late Map<String, Map<String, String>> _translations;

  // ... (Your existing translation data and methods)

  // ... (LocalizationsDelegate methods)

String translate(String key, String locale) {
    // Check if the key exists in your translations
    final translatedValue = _translations[locale]?[key];
    if (translatedValue != null) {
      return translatedValue;
    } else {
      // Implement fallback logic here (e.g., return the key itself or a default value)
      return 'translations[$locale][$key]'; // For testing, return the key enclosed in brackets
    }
  }

  // Static method to get an instance of the Messages object
  static Messages of(BuildContext context) {
    return Localizations.of<Messages>(context, Messages)!;
  }

  // Load translations from JSON files
  Future<void> loadTranslations() async {
    // Load the JSON files for each language
    _translations = {
      'es': await _loadLanguageFile('assets/translations/es.json'),
      'en': await _loadLanguageFile('assets/translations/en.json'),
    };
  }

  // Helper method to load a JSON file
  Future<Map<String, String>> _loadLanguageFile(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString) as Map<String, String>;
  }

  @override
  bool isSupported(Locale locale) {
    return ['es', 'en', 'ca'].contains(locale.languageCode);
  }

  @override
  Future<Messages> load(Locale locale) async {
    await loadTranslations(); // Load translations from JSON files
    return this;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Messages> old) {
    return false;
  }
}
