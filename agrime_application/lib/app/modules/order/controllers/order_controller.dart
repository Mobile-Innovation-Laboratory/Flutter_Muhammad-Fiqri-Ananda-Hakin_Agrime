import 'package:agrime_application/app/services/cart_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController extends GetxController {
  var textControllers = <String, TextEditingController>{}.obs;
  var userId = "".obs;

  @override
  void onInit() async {
    super.onInit();
    fetchUser();
  }

  @override
  void onReady() {
    fetchUser();
    // TODO: implement onReady
    super.onReady();
  }

  void fetchUser() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        userId.value = user.uid;
      } else {
        print("User is not logged in.");
      }
    });
  }

  void fetchOrders() async {
    var snapshot = await FirebaseFirestore.instance.collection("orders").get();
    for (var document in snapshot.docs) {
      textControllers[document.id] = TextEditingController(
        text: document["items"]["quantity"].toString(),
      );
    }
  }

  Future checkout() async {
    try {
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection("order")
          .where("status", isEqualTo: "pending")
          .get();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var doc in orderSnapshot.docs) {
        String productId = doc["items"]["itemId"];
        int quantity = doc["items"]["quantity"];

        batch.update(doc.reference, {"status": "Complete"});

        DocumentReference productRef =
            FirebaseFirestore.instance.collection("products").doc(productId);

        DocumentSnapshot productSnapshot = await productRef.get();

        if (productSnapshot.exists) {
          int currentStock = productSnapshot["stock"];
          int newStock = currentStock - quantity;

          if (newStock < 0) {
            newStock = 0;
          }

          batch.update(productRef, {"stock": newStock});
        }
      }

      await batch.commit();

      Get.snackbar(
          "Success", "All orders marked as Complete and stock updated");
    } catch (error) {
      Get.snackbar("Error", "Failed to checkout: $error");
    }
  }

  Future deleteItemCart(String docId) async {
    var item =
        FirebaseFirestore.instance.collection("order").doc(docId).delete();
  }

  void updateQuantity(String docId, String newValue) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? "";
    FirebaseAuth.instance.setLanguageCode("id");
    final userCredential =
        await FirebaseAuth.instance.signInWithCustomToken(token);
    final key = await userCredential.user!.getIdToken();
    int? newQuantity = int.tryParse(newValue);
    if (newQuantity == null || newQuantity < 1) {
      textControllers[docId]?.text = "1";

      Get.snackbar("Invalid", "Must More than 1");
      return;
    }
    final response = CartService().updateQuantityCart(newQuantity, docId, key);
  }
}
