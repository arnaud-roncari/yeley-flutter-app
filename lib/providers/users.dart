// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:yeley_frontend/commons/decoration.dart';
import 'package:yeley_frontend/commons/exception.dart';
import 'package:yeley_frontend/models/address.dart';
import 'package:yeley_frontend/services/api.dart';
import 'package:yeley_frontend/services/local_storage.dart';

class UsersProvider extends ChangeNotifier {
  bool isDeleting = false;
  bool isSettingAddress = false;
  Address? address;

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

  Future<void> getAddress() async {
    final String? stringifyJson = await LocalStorageService().getString("address");

    if (stringifyJson == null) {
      return;
    }

    final Map<String, dynamic> json = jsonDecode(stringifyJson);
    address = Address.fromJson(json);
    notifyListeners();
  }

  // Address will be saved in the secure storage.
  Future<void> setAddress(
    BuildContext context,
    String postalCode,
    String city,
    String address,
  ) async {
    try {
      isSettingAddress = true;
      notifyListeners();

      final String fullAddress = "$address, $postalCode $city, France";
      List<Location> locations = await locationFromAddress(fullAddress);

      if (locations.isEmpty) {
        throw Error();
      }

      final List<double> coordinates = [locations.first.longitude, locations.first.latitude];
      this.address = Address(
        address: address,
        city: city,
        postalCode: postalCode,
        fullAddress: fullAddress,
        coordinates: coordinates,
      );

      // User address is saved stringify and saved in local storage.
      await LocalStorageService().setString("address", jsonEncode(this.address!.toJson()));

      Navigator.pop(context);
    } catch (e) {
      // Display an error message if there is no address corresponding.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Aucune adresse ne correspond.',
            style: kRegular16.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
    } finally {
      isSettingAddress = false;
      notifyListeners();
    }
  }

  Future<void> getPhonePosition(BuildContext context) async {
    try {
      isSettingAddress = true;
      notifyListeners();

      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Error();
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Error();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Error();
      }

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      address = Address(
        address: placemarks.first.street ?? "",
        city: placemarks.first.name ?? "",
        postalCode: placemarks.first.postalCode ?? "",
        fullAddress:
            "${placemarks.first.street ?? ""}, ${placemarks.first.postalCode ?? ""} ${placemarks.first.name ?? ""}, France",
        coordinates: [
          position.longitude,
          position.latitude,
        ],
      );

      // User address is saved stringify and saved in local storage.
      await LocalStorageService().setString("address", jsonEncode(address!.toJson()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Accès à la position du téléphone impossible.',
            style: kRegular16.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
    } finally {
      isSettingAddress = false;
      notifyListeners();
      Navigator.pop(context);
    }
  }
}
