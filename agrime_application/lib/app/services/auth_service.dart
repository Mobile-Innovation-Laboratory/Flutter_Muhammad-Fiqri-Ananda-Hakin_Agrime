import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? "";
    try {
      if (token == "") {
        prefs.setBool('is_logged_in', false);
        prefs.remove('Token');
        Get.offAndToNamed('/login-page');
      }
      final userCredential =
          await FirebaseAuth.instance.signInWithCustomToken(token);

      return userCredential.toString();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-custom-token') {
        prefs.setBool('is_logged_in', false);
        prefs.remove('Token');
        Get.offAndToNamed('/login-page');
      }
    }
  }
}
