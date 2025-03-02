// ignore_for_file: unused_local_variable

import 'package:agrime_application/app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  TextEditingController email_controller = TextEditingController();
  TextEditingController username_controller = TextEditingController();
  TextEditingController firstname_controller = TextEditingController();
  TextEditingController lastname_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  var isLoading = false.obs;

  @override
  void onClose() {
    email_controller.dispose();
    username_controller.dispose();
    firstname_controller.dispose();
    lastname_controller.dispose();
    password_controller.dispose();
    super.onClose();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Get.snackbar(
          "Location Service is Enabled", "Please enable the service location");
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Location Service", "Location Service enabled");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Location Service", "Location service permanently denied");
      return false;
    }
    return true;
  }

  Future<Position?> getCurrentPosition() async {
    final permission = await _handleLocationPermission();
    if (!permission) return null;
    return await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);
  }

  Future register() async {
    isLoading.value = true;
    update();
    try {
      final position = await getCurrentPosition();
      final address = await placemarkFromCoordinates(
          position!.latitude, position.longitude);

      if (address.isNotEmpty) {
        final place = address.first;
        final response = await UserService().register(
          email: email_controller.text.trim(),
          password: password_controller.text.trim(),
          username: username_controller.text.trim(),
          firstname: firstname_controller.text.trim(),
          lastname: lastname_controller.text.trim(),
          location:
              "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}",
        );
        Get.back();
        return "Register Successfull";
      } else {
        print("Tidak dapat menemukan alamat untuk koordinat ini.");
      }
    } catch (e) {
      Get.snackbar("Login Failed", "$e");
    } finally {
      isLoading.value = false;
    }
  }
}
