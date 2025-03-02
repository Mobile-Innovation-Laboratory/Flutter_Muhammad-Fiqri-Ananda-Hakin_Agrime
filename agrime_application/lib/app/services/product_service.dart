import 'package:agrime_application/app/utils/constanta.dart';
import 'package:dio/dio.dart';

class ProductService {
  Future<Response> addingProduct(FormData formData, token) async {
    try {
      final response = await dio.post("$url/api/product/addproduct",
          data: formData,
          options: Options(headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token"
          }));
      return response;
    } catch (e) {
      throw Exception('Error Adding Data \n $e');
    }
  }

  Future<Response> updateData(FormData formData, token, id) async {
    try {
      final response = await dio.patch("$url/api/product/updateproduct/$id",
          data: formData,
          options: Options(headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token"
          }));
      return response;
    } on DioException catch (e) {
      print(e.response!.data);
      throw Exception(e);
    } catch (e) {
      throw Exception('Error Adding Data \n $e');
    }
  }
}
