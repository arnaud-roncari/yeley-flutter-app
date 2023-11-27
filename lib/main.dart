import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yeley_frontend/app.dart';
import 'package:yeley_frontend/commons/translations.dart';
import 'package:yeley_frontend/models/address.dart';
import 'package:yeley_frontend/providers/auth.dart';
import 'package:yeley_frontend/providers/users.dart';
import 'package:yeley_frontend/services/api.dart';
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

  /// Determine the first screens displayed.
  bool isSession = token != null && token.isNotEmpty;

  /// JWT is saved in ram, to be used later.
  Api.jwt = token;

  // Load the address, passed to the UsersProvider
  final String? stringifyJson = await LocalStorageService().getString("address");

  Address? address;
  if (stringifyJson != null) {
    final Map<String, dynamic> json = jsonDecode(stringifyJson);
    address = Address.fromJson(json);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider(address: address)),
      ],
      child: YeleyApp(isSession: isSession),
    ),
  );
}
