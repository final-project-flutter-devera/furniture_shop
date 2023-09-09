import 'package:furniture_shop/Objects/address.dart';
import 'package:furniture_shop/Objects/user.dart';
import 'package:furniture_shop/data/data_source/remote/user_firestore_service.dart';
import 'package:furniture_shop/data/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserFirestoreService _userFirestoreService;

  UserRepositoryImpl({UserFirestoreService? userFirestoreService})
      : _userFirestoreService = userFirestoreService ?? UserFirestoreService();

  @override
  Future<void> addUser(User user) {
    return _userFirestoreService.addUser(user);
  }

  @override
  Future<void> deleteUser(String userID) {
    return _userFirestoreService.deleteUser(userID);
  }

  @override
  Future<User> getUser(String userID) {
    return _userFirestoreService.getUser(userID);
  }

  @override
  Future<void> updateUser(String userID,
      {List<String>? role,
      String? name,
      String? emailAddres,
      String? phoneNumber,
      String? avatar,
      List<String>? following,
      List<Address>? shippingAddresses,
      List<String>? follower,
      bool? isDeleted}) {
    return _userFirestoreService.updateUser(userID,
        role: role,
        name: name,
        emailAddres: emailAddres,
        phoneNumber: phoneNumber,
        avatar: avatar,
        follower: follower,
        following: following,
        shippingAddresses: shippingAddresses,
        isDeleted: isDeleted);
  }
}
