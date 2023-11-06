// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:yeley_frontend/commons/exception.dart';
import 'package:yeley_frontend/services/api.dart';

class AuthProvider extends ChangeNotifier {
  bool isLogin = false;
  bool isRegistering = false;

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      isLogin = true;
      notifyListeners();
      await Api().login(email, password);

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (Route<dynamic> route) => false,
      );
    } catch (exception) {
      await ExceptionHelper.handle(context: context, exception: exception);
    } finally {
      isLogin = false;
      notifyListeners();
    }
  }

  Future<void> signup(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      isLogin = true;
      notifyListeners();
      await Api().signup(email, password);

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (Route<dynamic> route) => false,
      );
    } catch (exception) {
      await ExceptionHelper.handle(context: context, exception: exception);
    } finally {
      isLogin = false;
      notifyListeners();
    }
  }
}
