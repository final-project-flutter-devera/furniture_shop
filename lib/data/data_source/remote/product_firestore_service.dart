import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Objects/product.dart';
import 'package:furniture_shop/data/data_source/product_data_service.dart';

class ProductFirestoreService implements ProductDataService {
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  @override
  Future<void> addProduct(Product product) {
    return products
        .doc(product.id)
        .set(product.toJson())
        .then((value) => debugPrint('Added a User with ID: ${product.id}'))
        .catchError((error) => debugPrint('Failed to add a User: $error'));
  }

  @override
  Future<void> deleteProduct(String productID) {
    return products
        .doc(productID)
        .delete()
        .then((value) => debugPrint('Deleted a user with ID: $productID'))
        .catchError((error) => debugPrint('Failed to delete a user: $error'));
  }

  @override
  Future<Product> getUser(String productID) async {
    Product? product;
    await products.doc(productID).get().then((querySnapshot) {
      debugPrint('Get user $productID successfully');
      product = Product.fromJson(querySnapshot.data() as Map<String, dynamic>);
    });
    return Future.value(product);
  }

  @override
  Future<void> updateProduct(String productID,
      {String? vendorID,
      String? name,
      String? description,
      List<String>? images,
      List<String>? mainCategory,
      List<String>? subCategory,
      int? stock,
      double? discount,
      Timestamp? discountStart,
      Timestamp? discountEnd,
      double? price,
      bool? isDeleted}) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }
}
