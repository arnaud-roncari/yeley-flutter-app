import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yeley_frontend/app.dart';
import 'package:yeley_frontend/commons/translations.dart';
import 'package:yeley_frontend/providers/auth.dart';
import 'package:yeley_frontend/providers/establishments.dart';
import 'package:yeley_frontend/providers/users.dart';
import 'package:yeley_frontend/services/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Set the application oriention to portrait only.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Translations.loadTranslations();

  /// Verify if an accessToken was stored.
  /// If there is, the user don't have to login.
  String? token = await LocalStorageService().getString("JWT");
  bool isSession = token != null && token.isNotEmpty;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => EstablishmentsProvider()),
      ],
      child: YeleyApp(isSession: isSession),
    ),
  );
}

// - demander des versions plus clean des logos
// - Mettre les textfield de geoloc puis -> Mettre en place la geoloce (charger celle du tel + rentrer un address)

// - Splash screen
// - Charger 10 images par 10 (cache ?)
// - tester sur véritable iphone (besoin d'un compte dev ?)
// - accéder à la geoloc du téléphone
// - demander les accès aux logo/droits au figma


