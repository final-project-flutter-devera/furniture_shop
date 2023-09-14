import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class Product {
  final String id; //Primary key
  final String vendorID;
  String name;
  String description;
  List<String> images;
  List<String> mainCategory;
  List<String>? subCategory;
  int stock;
  double discount;
  Timestamp? discountStart;
  Timestamp? discountEnd;
  double price;
  bool isDeleted;
  Product({
    required this.id,
    required this.vendorID,
    required this.name,
    required this.description,
    required this.images,
    required this.mainCategory,
    this.subCategory,
    required this.price,
    required this.stock,
    required this.discount,
    this.discountStart,
    this.discountEnd,
    this.isDeleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorID': vendorID,
      'name': name,
      'description': description,
      'images': images,
      'mainCategory': mainCategory,
      'subCategory': subCategory,
      'price': price,
      'stock': stock,
      'discount': discount,
      'discountStart': discountStart,
      'discountEnd': discountEnd,
      'isDeleted': isDeleted,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'] as String,
        vendorID: json['vendorID'],
        name: json['name'] as String,
        description: json['description'] as String,
        images: json['images'] as List<String>,
        mainCategory: json['mainCategory'] as List<String>,
        subCategory: json['subCategory'] as List<String>?,
        price: json['price'] as double,
        stock: json['stock'],
        discount: json['discount'],
        discountStart: json['discountStart'],
        discountEnd: json['discountEnd'],
        isDeleted: json['isDeleted'] as bool);
  }
}
