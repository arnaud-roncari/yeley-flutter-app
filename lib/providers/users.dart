// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:yeley_frontend/commons/exception.dart';
import 'package:yeley_frontend/services/api.dart';
import 'package:yeley_frontend/services/local_storage.dart';

class UsersProvider extends ChangeNotifier {
  bool isDeleting = false;

  Future<void> deleteAccount(
    BuildContext context,
  ) async {
    try {
      isDeleting = true;
      notifyListeners();
      await Api().deleteUserAccount();
      // JWT is removed.
      await LocalStorageService().setString("JWT", "");
      // The user is redirected on the signup page.
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/signup',
        (Route<dynamic> route) => false,
      );
    } catch (exception) {
      await ExceptionHelper.handle(context: context, exception: exception);
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }

  Future<void> logout(
    BuildContext context,
  ) async {
    // JWT is removed.
    await LocalStorageService().setString("JWT", "");
    // The user is redirected on the signup page.
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/signup',
      (Route<dynamic> route) => false,
    );
  }
}
