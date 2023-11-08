class Validator {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est vide.';
    }
    if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return null;
    }
    return "Veuillez rentrer un email valide.";
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est vide.';
    }
    if (value.length < 8) {
      return "Votre mot de passe doit contenir minimum 8 charactères.";
    }

    if (value.length > 64) {
      return "Votre mot de passe doit contenir maximum 64 charactères.";
    }
    return null;
  }

  static String? isNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est vide.';
    }
    return null;
  }
}
