import 'package:agrime_application/app/data/models/user_model.dart';
import 'package:agrime_application/app/utils/constanta.dart';
import 'package:dio/dio.dart';

class UserService {
  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final response = await dio.post("$url/api/users/login",
          data: {'email': email, 'password': password});
      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Login Failed');
      }
    } catch (e) {
      print(e);
      throw Exception('Username/Password Salah');
    }
  }

  Future<void> register(
      {required String email,
      required String password,
      required String username,
      required String firstname,
      required String lastname,
      required String location}) async {
    try {
      final response = await dio.post('$url/api/users/register', data: {
        'email': email,
        'password': password,
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'location': location,
      });

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception("Error Register Data");
      }
    } on DioException catch (e) {
      throw Exception(e.response!.data['error']['message']);
    }
  }
}
