import 'package:yeley_frontend/commons/translations.dart';

extension TranslationExtension on String {
  /// Translate the string to the current language
  ///
  /// If the translation is not found, return the string with a warning
  String translate() {
    if (Translations.translations.containsKey(this)) {
      final Map<String, String> translation = Translations.translations[this]!;
      if (translation.containsKey("fr")) {
        String translated = translation["fr"]!;
        return translated;
      }
    }
    return '<unknown translation "$this">';
  }
}
