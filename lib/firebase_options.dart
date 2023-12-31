// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAG5UZtlqg16Fjr9QoeIuM_QlKREsgK6IA',
    appId: '1:753971544701:web:e059aa0b6488308cff6714',
    messagingSenderId: '753971544701',
    projectId: 'furniture-shop-devera',
    authDomain: 'furniture-shop-devera.firebaseapp.com',
    databaseURL: 'https://furniture-shop-devera-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'furniture-shop-devera.appspot.com',
    measurementId: 'G-FLTH4JFBB0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaHeKKymQEze7rZVFqPRK1ED5fyJv27ns',
    appId: '1:753971544701:android:fbd3e20ec1970ddfff6714',
    messagingSenderId: '753971544701',
    projectId: 'furniture-shop-devera',
    databaseURL: 'https://furniture-shop-devera-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'furniture-shop-devera.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0Be1QSiRIAliJr61R80lBd7MesczZoQI',
    appId: '1:753971544701:ios:fc57b6718beaebefff6714',
    messagingSenderId: '753971544701',
    projectId: 'furniture-shop-devera',
    databaseURL: 'https://furniture-shop-devera-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'furniture-shop-devera.appspot.com',
    androidClientId: '753971544701-n5ld5mc8v9vcsm23pbeqlr1ctk4bmomk.apps.googleusercontent.com',
    iosClientId: '753971544701-o99jivfo2uigqsghd23duqqlvfjmm9vt.apps.googleusercontent.com',
    iosBundleId: 'com.example.funitureShop',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB0Be1QSiRIAliJr61R80lBd7MesczZoQI',
    appId: '1:753971544701:ios:d35bc8ffb4c55d71ff6714',
    messagingSenderId: '753971544701',
    projectId: 'furniture-shop-devera',
    databaseURL: 'https://furniture-shop-devera-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'furniture-shop-devera.appspot.com',
    androidClientId: '753971544701-n5ld5mc8v9vcsm23pbeqlr1ctk4bmomk.apps.googleusercontent.com',
    iosClientId: '753971544701-f29q7pt6188f4k0bflqcl75b3445kpas.apps.googleusercontent.com',
    iosBundleId: 'com.example.funitureShop.RunnerTests',
  );
}
