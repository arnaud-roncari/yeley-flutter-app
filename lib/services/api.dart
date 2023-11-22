import 'dart:convert';
import 'package:http/http.dart';
import 'package:yeley_frontend/commons/exception.dart';
import 'package:yeley_frontend/commons/constants.dart';
import 'package:yeley_frontend/models/establishment.dart';
import 'package:yeley_frontend/models/tag.dart';

class Api {
  static final Api _instance = Api._internal();
  static String? jwt;
  factory Api() {
    return _instance;
  }

  Future<String> signup(
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
      ExceptionHelper.fromResponse(response);
    }
    return jsonDecode(response.body)["accessToken"];
  }

  Future<String> login(
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

    if (response.statusCode < 200 || response.statusCode > 299) {
      ExceptionHelper.fromResponse(response);
    }
    return jsonDecode(response.body)["accessToken"];
  }

  Future<void> deleteUserAccount() async {
    Response response = await delete(
      Uri.parse('$kApiUrl/users'),
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );
    if (response.statusCode < 200 || response.statusCode > 299) {
      ExceptionHelper.fromResponse(response);
    }
  }

  Future<List<Tag>> getTags() async {
    Response response = await get(
      Uri.parse('$kApiUrl/tags/all'),
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );
    if (response.statusCode < 200 || response.statusCode > 299) {
      ExceptionHelper.fromResponse(response);
    }
    final Map<String, dynamic> body = jsonDecode(response.body);
    return Tag.fromJsons(body["tags"]);
  }

  Future<List<Establishment>> getNearbyEstablishments(
    int range,
    List<double> coordinates,
    EstablishmentType type,
    List<Tag> tags, {
    bool favorite = false,
  }) async {
    Response response = await post(
      Uri.parse('$kApiUrl/users/nearby/establishments${favorite ? "?liked=true" : ""}'),
      headers: {
        'Authorization': 'Bearer $jwt',
        'Content-type': 'application/json',
      },
      body: jsonEncode(
        {
          "range": range,
          'coordinates': coordinates,
          "type": type.name,
          "tags": Tag.getIds(tags),
        },
      ),
    );

    if (response.statusCode < 200 || response.statusCode > 299) {
      ExceptionHelper.fromResponse(response);
    }
    final Map<String, dynamic> body = jsonDecode(response.body);
    return Establishment.fromJsons(body["nearbyEstablishments"]);
  }

  Future<void> like(Establishment establishment) async {
    Response response = await get(
      Uri.parse('$kApiUrl/users/like/establishment/${establishment.id}'),
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );
    if (response.statusCode < 200 || response.statusCode > 299) {
      ExceptionHelper.fromResponse(response);
    }
  }

  Future<void> unlike(Establishment establishment) async {
    Response response = await get(
      Uri.parse('$kApiUrl/users/unlike/establishment/${establishment.id}'),
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );
    if (response.statusCode < 200 || response.statusCode > 299) {
      ExceptionHelper.fromResponse(response);
    }
  }

  Api._internal();
}
