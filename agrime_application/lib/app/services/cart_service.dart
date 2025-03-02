import 'package:agrime_application/app/utils/constanta.dart';
import 'package:dio/dio.dart';

class CartService {
  Future<Response> addCart(
    String itemId,
    int quantity,
    String userId,
    String image,
    int price,
    token,
    itemName,
  ) async {
    try {
      final response = await dio.post("$url/api/cart/addcart",
          data: {
            "itemId": itemId,
            "quantity": quantity,
            "userId": userId,
            "image": image,
            "price": price,
            "itemName": itemName,
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          }));
      return response;
    } catch (e) {
      throw Exception('Error Adding Data \n $e');
    }
  }

  Future<Response> updateQuantityCart(amount, id, token) async {
    try {
      print(id);
      final response = await dio.patch("$url/api/cart/updatecart/$id",
          data: {
            "quantity": amount,
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          }));
      return response;
    } catch (e) {
      print(e);
      throw Exception('Error Adding Data');
    }
  }
}
