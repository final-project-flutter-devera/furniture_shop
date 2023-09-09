import 'package:furniture_shop/Objects/address.dart';

class User {
  final String id;
  final List<String> role; // Can have multiple role?
  String name;
  String? emailAddress;
  String? phoneNumber;
  String? avatar;
  List<String>? following;
  List<String>? follower;
  List<Address> shippingAddress;
  bool isDeleted;

  User(
      {required this.id,
      required this.role,
      required this.name,
      this.emailAddress,
      this.phoneNumber = '',
      this.avatar,
      this.isDeleted = false,
      this.following,
      this.follower,
      this.shippingAddress = const []});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'name': name,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
      'following': following,
      'follower': follower,
      'isDeleted': isDeleted,
      //TODO: TO JSON FOR SHIPPING ADDRESS
      'shippingAddress': shippingAddress.map(
        (e) => e.toJson(),
      )
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      role: (json['role'] as List).map((e) => e as String).toList(),
      name: json['name'],
      emailAddress: json['emailAddress'],
      phoneNumber: json['phoneNumber'],
      avatar: json['avatar'],
      follower: (json['follower'] as List?)?.map((e) => e as String).toList(),
      following: (json['following'] as List?)?.map((e) => e as String).toList(),
      isDeleted: json['isDeleted'],
      shippingAddress: (json['shippingAddress'] as List<dynamic>)
          .map((e) => Address.fromJson(e))
          .toList(),
    );
  }
}
