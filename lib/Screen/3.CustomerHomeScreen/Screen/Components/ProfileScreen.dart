import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Screen/16.%20ProfileRoutes/MyShippingAddress/my_shipping_address.dart';
import 'package:furniture_shop/Widgets/AppBarButton.dart';
import 'package:furniture_shop/Widgets/AppBarTitle.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Widgets/ShowAlertDialog.dart';
import '../../../13. MyOrderScreen/My_Order_Screen.dart';
import 'Profile/EditInfo.dart';
import 'SearchScreen.dart';

class ProfileScreen extends StatefulWidget {
  final String documentId;

  const ProfileScreen({super.key, required this.documentId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
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
  Widget build(BuildContext context) {
    print('ID: ${widget.documentId}');
    final wMQ = MediaQuery.of(context).size.width;
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseAuth.instance.currentUser!.isAnonymous
          ? anonymous.doc(widget.documentId).get()
          : users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColor.white,
              leading: AppBarButtonPush(
                aimRoute: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen()));
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
            body: Padding(
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
                            child: data['profileimage'] == ''
                                ? const CircleAvatar(
                                    backgroundColor: AppColor.white,
                                    radius: 40,
                                    backgroundImage: AssetImage(
                                        'assets/Images/Images/avatarGuest.jpg'),
                                  )
                                : CircleAvatar(
                                    backgroundColor: AppColor.white,
                                    radius: 40,
                                    child: data['avatar'] ??
                                        Text(
                                          (() {
                                            final _initials = (data['name']
                                                    as String)
                                                .split(' ')
                                                .reduce((value, element) =>
                                                    value[0] +
                                                    element[0].toUpperCase());
                                            return _initials.substring(
                                                _initials.length - 2);
                                          })(),
                                          style: TextStyle(
                                              color: AppColor.black,
                                              fontSize: 40),
                                        ),
                                  ),
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
                                    text: data['name'] == ''
                                        ? 'Guest'.toUpperCase()
                                        : data['name'].toUpperCase(),
                                    style: GoogleFonts.nunito(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.black,
                                    ),
                                  ),
                                  const TextSpan(text: '\n'),
                                  TextSpan(
                                    text: data['email'] == ''
                                        ? 'Anonymous'
                                        : data['email'],
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
                                builder: (context) => EditInfo(
                                  data: data,
                                ),
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
