import 'dart:convert';
import 'package:http/http.dart';
import 'package:yeley_frontend/commons/exception.dart';
import 'package:yeley_frontend/commons/constants.dart';
import 'package:yeley_frontend/services/local_storage.dart';

class Api {
  static final Api _instance = Api._internal();
  factory Api() {
    return _instance;
  }

  static Future<String> getJWT() async {
    String? jwt = await LocalStorageService().getString("JWT");
    if (jwt == null) {
      throw SessionExpired();
    }
    return jwt;
  }

  Future<void> signup(
    String email,
    String password,
  ) async {
    Response response = await post(
      Uri.parse('$kApiUrl/auth/signup'),
      headers: {
        'Content-type': 'application/json',
      },
      body: jsonEncode(
        {
          "email": email,
          "password": password,
        },
      ),
    );

    if (response.statusCode < 200 || response.statusCode > 299) {
      return ExceptionHelper.fromResponse(response);
    }

    await LocalStorageService().setString("JWT", jsonDecode(response.body)["accessToken"]);
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    Response response = await post(
      Uri.parse('$kApiUrl/auth/login'),
      headers: {
        'Content-type': 'application/json',
      },
      body: jsonEncode(
        {
          "email": email,
          "password": password,
        },
      ),
    );
    // TODO Rendre p^lus sexy ces if avec un fonction is200StatusCode (ou autre)
    if (response.statusCode < 200 || response.statusCode > 299) {
      return ExceptionHelper.fromResponse(response);
    }

    await LocalStorageService().setString("JWT", jsonDecode(response.body)["accessToken"]);
  }

  Api._internal();
}
