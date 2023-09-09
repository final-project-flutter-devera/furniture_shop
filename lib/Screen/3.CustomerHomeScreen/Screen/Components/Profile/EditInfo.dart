import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Widgets/AppBarButton.dart';
import 'package:furniture_shop/Widgets/AppBarTitle.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../Widgets/MyMessageHandler.dart';

class EditInfo extends StatefulWidget {
  final dynamic data;

  const EditInfo({super.key, required this.data});

  @override
  State<EditInfo> createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late String name;
  late String phone;
  late String address;
  late String image;

  bool processing = false;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  dynamic _pickedImageError;

  void _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage!;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Future uploadImage() async {
    if (_imageFile != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('customer-Images/${widget.data['profileimage']}.jpg');
        await ref.putFile(File(_imageFile!.path));
        image = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      image = widget.data['profileimage'];
    }
  }

  Future editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'name': name,
        'phone': phone,
        'address': address,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        processing = true;
      });
      _formKey.currentState!.save();
      await uploadImage().whenComplete(
        () async => editStoreData(),
      );
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          leading: const AppBarBackButtonPop(),
          title: const AppBarTitle(label: 'Edit Information'),
          centerTitle: true,
          actions: [
            processing == true
                ? Center(child: CircularProgressIndicator())
                : IconButton(
                    onPressed: () {
                      saveChanges();
                    },
                    icon: const Icon(Icons.save, color: AppColor.black),
                  ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColor.black,
                        radius: 57,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: AppColor.white,
                          child: widget.data['avatar'] ??
                              Text(
                                (() {
                                  final _initials = (widget.data['name']
                                          as String)
                                      .split(' ')
                                      .reduce((value, element) =>
                                          value[0] + element[0].toUpperCase());
                                  return _initials
                                      .substring(_initials.length - 2);
                                })(),
                                style: TextStyle(
                                    color: AppColor.black, fontSize: 40),
                              ),
                        ),
                      ),
                      Icon(Icons.arrow_forward),
                      CircleAvatar(
                        backgroundColor: AppColor.black,
                        radius: 57,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: AppColor.white,
                          backgroundImage: _imageFile == null
                              ? null
                              : FileImage(File(_imageFile!.path)),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _pickImageFromCamera();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15))),
                            child: IconButton(
                              icon: const Icon(
                                Icons.photo,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _pickImageFromGallery();
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  PhysicalModel(
                    color: AppColor.white,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              name = value!;
                            },
                            initialValue: widget.data['name'],
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF909090),
                              ),
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              address = value!;
                            },
                            initialValue: widget.data['address'],
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              labelStyle: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF909090),
                              ),
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              phone = value!;
                            },
                            initialValue: widget.data['phone'],
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              labelStyle: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF909090),
                              ),
                            ),
                          ),
                        ],
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
