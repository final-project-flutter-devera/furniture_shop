import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Providers/Auth_reponse.dart';
import 'package:furniture_shop/Providers/user_provider.dart';
import 'package:furniture_shop/Screen/16.%20ProfileRoutes/MyShippingAddress/my_shipping_address.dart';
import 'package:furniture_shop/Widgets/AppBarButton.dart';
import 'package:furniture_shop/Widgets/AppBarTitle.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../Widgets/ShowAlertDialog.dart';
import '../../../13. MyOrderScreen/My_Order_Screen.dart';
import 'Profile/EditInfo.dart';
import 'SearchScreen.dart';
import 'package:furniture_shop/Objects/user.dart' as appUser;

class ProfileScreen extends StatefulWidget {
  final String documentId;

  const ProfileScreen({super.key, required this.documentId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  late appUser.User user;
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  List<String> tabName = [
    'My Order',
    'Shipping Address',
    'Payment Method',
    'My review',
    'Settings',
  ];
  List tabRoute = [
    MyOrderScreen(),
    MyShippingAddress(),
  ];

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  _getUserData() async {
    user = await context.read<UserProvider>().getUser();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('ID: ${widget.documentId}');
    final wMQ = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.white,
        leading: AppBarButtonPush(
          aimRoute: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen()));
          },
          icon: SvgPicture.asset(
            'assets/Images/Icons/search.svg',
            height: 24,
            width: 24,
          ),
        ),
        title: const AppBarTitle(label: 'Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/Images/Icons/Logout.svg',
                height: 24, width: 24),
            onPressed: () async {
              MyAlertDialog.showMyDialog(
                context: context,
                title: 'Log out',
                content: 'Are you sure log out?',
                tabNo: () {
                  Navigator.pop(context);
                },
                tabYes: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                        context, '/Welcome_boarding');
                  }
                },
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColor.amber,
                            radius: 45,
                            child: CircleAvatar(
                                backgroundColor: AppColor.white,
                                radius: 40,
                                child: user.avatar == null || user.avatar == ''
                                    ? Text(
                                        (() {
                                          final _initials = user.name
                                              .split(' ')
                                              .reduce((value, element) =>
                                                  value[0] +
                                                  element[0].toUpperCase());
                                          return _initials
                                              .substring(_initials.length - 2);
                                        })(),
                                        style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: 40),
                                      )
                                    : Image.network(user.avatar!)),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: wMQ * 0.5,
                            child: Text.rich(
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: user.name == ''
                                        ? 'Guest'.toUpperCase()
                                        : user.name.toUpperCase(),
                                    style: GoogleFonts.nunito(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.black,
                                    ),
                                  ),
                                  const TextSpan(text: '\n'),
                                  TextSpan(
                                    text: user.emailAddress == ''
                                        ? 'Anonymous'
                                        : user.emailAddress,
                                    style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditInfo(user: user),
                              ),
                            );
                          },
                          icon:
                              SvgPicture.asset('assets/Images/Icons/edit.svg')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: tabName.length,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => tabRoute[index]));
                            },
                            child: PhysicalModel(
                              elevation: 3,
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.grey,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: 80,
                                  width: wMQ,
                                  decoration: const BoxDecoration(
                                    color: AppColor.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tabName[index],
                                          style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                        ),
                                        const Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
    // Text("Full Name: ${data['full_name']} ${data['last_name']}");
  }
}
