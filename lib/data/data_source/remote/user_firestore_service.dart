import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Objects/address.dart';
import 'package:furniture_shop/Objects/user.dart';
import 'package:furniture_shop/data/data_source/user_data_service.dart';

class UserFirestoreService implements UserDataService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Future<void> addUser(User user) {
    return users
        .doc(user.id)
        .set(user.toJson())
        .then((value) => debugPrint('Added a User with ID: ${user.id}'))
        .catchError((error) => debugPrint('Failed to add a User: $error'));
  }

  @override

  ///DO NOT USE WHEN USER REQUEST TO DELETE. To delete a user set flag isDeleted to true
  Future<void> deleteUser(String userID) {
    return users
        .doc(userID)
        .delete()
        .then((value) => debugPrint('Deleted a user with ID: $userID'))
        .catchError((error) => debugPrint('Failed to delete a user: $error'));
  }

  @override
  Future<User> getUser(String userID) async {
    User? user;
    await users.doc(userID).get().then((querySnapshot) {
      debugPrint('Get user $userID successfully');
      user = User.fromJson(querySnapshot.data() as Map<String, dynamic>);
    });
    return Future.value(user);
  }

  @override
  Future<void> updateUser(
    String userID, {
    List<String>? role,
    String? name,
    String? emailAddres,
    String? phoneNumber,
    String? avatar,
    List<String>? following,
    List<String>? follower,
    List<Address>? shippingAddresses,
    bool? isDeleted,
  }) {
    final updates = {
      if (role != null) 'role': role,
      if (name != null) 'name': name,
      if (emailAddres != null) 'emailAddres': emailAddres,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (avatar != null) 'avatar': avatar,
      if (following != null) 'following': following,
      if (follower != null) 'follower': follower,
      if (shippingAddresses != null)
        'shippingAddress': shippingAddresses.map((e) => e.toJson()),
      if (isDeleted != null) 'isDeleted': isDeleted,
    };
    if (updates.isNotEmpty) {
      return users
          .doc(userID)
          .update(updates)
          .then((value) => debugPrint('Updated a user: $userID'))
          .catchError((error) => debugPrint('Failed to update a user: $error'));
    } else {
      debugPrint('Nothing to update');
      return Future.value(null);
    }
  }
}
