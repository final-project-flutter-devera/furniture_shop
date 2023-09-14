import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniture_shop/Objects/product.dart';

abstract class ProductDataService {
  Future<void> addProduct(Product product);
  Future<void> updateProduct(
    String productID, {
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
    bool? isDeleted,
  });
  Future<void> deleteProduct(String productID);
  Future<Product> getUser(String productID);
}
