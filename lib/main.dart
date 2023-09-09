import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:furniture_shop/Providers/Cart_Provider.dart';
import 'package:furniture_shop/Providers/Favorites_Provider.dart';
import 'package:furniture_shop/Providers/user_provider.dart';
import 'package:furniture_shop/Screen/16.%20ProfileRoutes/MyShippingAddress/my_shipping_address.dart';
import 'package:furniture_shop/localization/localization_delegate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Providers/Stripe_ID.dart';
import 'Screen/1. Boarding/BoardingScreen.dart';
import 'Screen/2. Login - Signup/Login.dart';
import 'Screen/2. Login - Signup/LoginSupplier.dart';
import 'Screen/2. Login - Signup/Signup.dart';
import 'Screen/2. Login - Signup/SignupSupplier.dart';
import 'Screen/3.CustomerHomeScreen/Screen/CustomerHomeScreen.dart';
import 'Screen/4. SupplierHomeScreen/Screen/SupplierHomeScreen.dart';
import 'firebase_options.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent));
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
      .then((value) => const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Favorites()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: Locale(Platform.localeName),
        localizationsDelegates: const [
          AppLocalizationDelegate(),
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale.fromSubtags(languageCode: 'vi'),
          Locale.fromSubtags(languageCode: 'en'),
        ],
        initialRoute: '/Welcome_boarding',
        routes: {
          '/Welcome_boarding': (context) => const BoardingScreen(),
          '/Customer_screen': (context) => const CustomerHomeScreen(),
          '/Supplier_screen': (context) => const SupplierHomeScreen(),
          '/Login_cus': (context) => const Login(),
          '/Login_sup': (context) => const LoginSupplier(),
          '/Signup_cus': (context) => const Signup(),
          '/Signup_sup': (context) => const SignupSupplier(),
        });
  }
}
