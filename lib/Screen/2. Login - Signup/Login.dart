import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Providers/Auth_reponse.dart';
import 'package:furniture_shop/Screen/3.CustomerHomeScreen/Screen/CustomerHomeScreen.dart';
import 'package:furniture_shop/Widgets/CheckValidation.dart';
import 'package:furniture_shop/Widgets/MyMessageHandler.dart';
import 'package:furniture_shop/localization/app_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constants/Colors.dart';
import '../../Widgets/LogoLoginSignup.dart';
import '../../Widgets/SocialLogin.dart';
import '../../Widgets/TextLoginWidget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool visiblePassword = false;
  bool resendVerification = false;
  late String email;
  late String password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool processingGuest = false;
  bool processingAccountMail = false;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  late String _uid;

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        processingAccountMail = true;
      });
      try {
        await AuthRepo.signInWithEmailAndPassword(email, password);
        await AuthRepo.reloadUser();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const CustomerHomeScreen()));
        // if (await AuthRepo.checkVerifiedMail()) {
        //   _formKey.currentState!.reset();

        //   await Future.delayed(const Duration(microseconds: 100)).whenComplete(
        //       () => Navigator.pushReplacement(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => const CustomerHomeScreen())));
        // } else {
        //   MyMessageHandler.showSnackBar(
        //       _scaffoldKey, 'Please check inbox & verify mail');
        //   setState(() {
        //     processingAccountMail = false;
        //     resendVerification = true;
        //   });
        // }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          MyMessageHandler.showSnackBar(
            _scaffoldKey,
            'User not found',
          );
          setState(() {
            processingAccountMail = false;
          });
        } else if (e.code == 'wrong-password') {
          MyMessageHandler.showSnackBar(
            _scaffoldKey,
            'Your password provided is wrong',
          );
          setState(() {
            processingAccountMail = false;
          });
        }
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill al fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    double wMQ = MediaQuery.of(context).size.width;
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoLoginSignup(wMQ: wMQ),
                  TextLoginSignup(
                    label: context.localize('welcome_1') + '\n',
                    label2: context.localize('welcome_2'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: PhysicalModel(
                      color: Colors.white,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        MyMessageHandler.showSnackBar(
                                          _scaffoldKey,
                                          'please enter your email',
                                        );
                                        return 'please enter your email';
                                      } else if (value.isValidEmail() ==
                                          false) {
                                        MyMessageHandler.showSnackBar(
                                          _scaffoldKey,
                                          'invalid email',
                                        );
                                        return 'invalid email';
                                      } else if (value.isValidEmail() == true) {
                                        return null;
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        email = value;
                                      });
                                    },
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      labelText: 'Mail',
                                      labelStyle: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF909090),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        password = value;
                                      });
                                    },
                                    obscureText: !visiblePassword,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF909090),
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            visiblePassword = !visiblePassword;
                                          });
                                        },
                                        icon: Icon(visiblePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(minHeight: 10),
                              child: resendVerification == true
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: MaterialButton(
                                        color: AppColor.amber,
                                        onPressed: () async {
                                          try {
                                            await FirebaseAuth
                                                .instance.currentUser!
                                                .sendEmailVerification();
                                            Future.delayed(
                                                    const Duration(seconds: 3))
                                                .whenComplete(() {
                                              setState(() {
                                                resendVerification = false;
                                              });
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        child: Text(
                                          'Resend verification mail (click)',
                                          style: GoogleFonts.nunito(
                                              fontSize: 16,
                                              color: AppColor.black),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Forgot Password',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF303030),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: processingAccountMail == true
                                  ? const CircularProgressIndicator()
                                  : InkWell(
                                      onTap: () {
                                        signIn();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: wMQ * 0.65,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Log in',
                                            style: GoogleFonts.nunito(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SocialLogin(
                                  image: 'assets/Images/Icons/google.jpg',
                                  label: 'Google',
                                  onPressed: () {},
                                ),
                                SocialLogin(
                                  image: 'assets/Images/Icons/fb.png',
                                  label: 'Facebook',
                                  onPressed: () {},
                                ),
                                processingGuest == true
                                    ? const CircularProgressIndicator()
                                    : SocialLogin(
                                        image: 'assets/Images/Icons/guest.png',
                                        label: 'Guest',
                                        onPressed: () async {
                                          setState(() {
                                            processingGuest = true;
                                          });
                                          await FirebaseAuth.instance
                                              .signInAnonymously()
                                              .whenComplete(() async {
                                            _uid = FirebaseAuth
                                                .instance.currentUser!.uid;
                                            await anonymous.doc(_uid).set({
                                              'name': '',
                                              'email': '',
                                              'phone': '',
                                              'address': '',
                                              'profileimage': '',
                                              'cid': _uid,
                                              'role': 'Supplier'
                                            });
                                          });
                                          if (context.mounted) {
                                            Navigator.pushReplacementNamed(
                                                context, '/Customer_screen');
                                          }
                                        },
                                      ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/Signup_cus');
                                },
                                child: Text(
                                  'SIGN UP',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF303030),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: MaterialButton(
                                  height: 50,
                                  color: AppColor.grey,
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/Login_sup');
                                  },
                                  child: Text(
                                    'SUPPLIER LOGIN',
                                    style: GoogleFonts.nunito(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
