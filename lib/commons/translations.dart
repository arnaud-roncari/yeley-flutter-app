import 'dart:convert';

import 'package:flutter/services.dart';

class Translations {
  static Map<String, Map<String, String>> translations = {};
  static bool _loaded = false;

  static Future<void> loadTranslations() async {
    if (_loaded) {
      return;
    }

    try {
      final String translationResponse = await rootBundle.loadString('assets/translations.json');

      final Map<String, dynamic> translationsJson = jsonDecode(translationResponse);

      translations = translationsJson.map((key, value) {
        return MapEntry<String, Map<String, String>>(
          key,
          (value as Map<String, dynamic>).cast(),
        );
      });

      _loaded = true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
