// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:yeley_frontend/commons/decoration.dart';
import 'package:yeley_frontend/services/local_storage.dart';

abstract class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  Future<void> handle(BuildContext context);
}

class SessionExpired extends ApiException {
  SessionExpired() : super('Session expirée, veuillez vous reconnecter.');

  @override
  Future<void> handle(BuildContext context) async {
    await LocalStorageService().setString('JWT', '');
    Navigator.pushNamed(context, '/signup');
  }
}

class Message extends ApiException {
  Message(String message) : super(message);

  @override
  Future<void> handle(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kMainGreen,
        content: Text(
          message,
          style: kRegular16.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ExceptionHelper {
  /// Throw exception [ApiException], from the Api Jobme service, based on status codes.
  static void fromResponse(Response response) {
    Map<String, dynamic> body = jsonDecode(response.body);
    switch (response.statusCode) {
      case 401:
        throw SessionExpired();
      default:
        throw Message(body['message'] ?? 'Oups... Une erreur est survenue.');
    }
  }

  static Future<void> handle({required BuildContext context, required Object exception}) async {
    if (exception is ApiException) {
      await exception.handle(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kMainGreen,
          content: Text(
            '$exception',
            style: kRegular16.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}
