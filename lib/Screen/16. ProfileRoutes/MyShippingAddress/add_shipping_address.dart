import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:furniture_shop/Objects/address.dart';
import 'package:furniture_shop/Screen/16.%20ProfileRoutes/MyShippingAddress/Components/app_text_field.dart';
import 'package:furniture_shop/Screen/16.%20ProfileRoutes/MyShippingAddress/pick_location.dart';
import 'package:furniture_shop/Widgets/action_button.dart';
import 'package:furniture_shop/Widgets/default_app_bar.dart';
import 'package:furniture_shop/localization/app_localization.dart';
import 'package:google_fonts/google_fonts.dart';

class AddShipingAddress extends StatefulWidget {
  final ValueChanged<Address> onTap;

  AddShipingAddress({super.key, required this.onTap});

  @override
  State<AddShipingAddress> createState() => _AddShippingAddressState();
}

class _AddShippingAddressState extends State<AddShipingAddress> {
  // String? countryValue = '';
  // String? cityValue = '';
  // String? districtValue = '';
  String? address = '';
  String? errorMessage;
  double? latitude;
  double? longitude;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    streetController.dispose();
    zipcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(
          context: context,
          title: context.localize('add_shipping_address_app_bar_title')),
      body: Form(
        key: _formKey,
        child: ListView(children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: AppTextFormField(
              isNumber: false,
              controller: nameController,
              labelText: context.localize('label_full_name'),
              hintText: context.localize('place_holder_full_name'),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: AppTextFormField(
              isNumber: false,
              controller: streetController,
              labelText: context.localize('label_address'),
              hintText: context.localize('place_holder_address'),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: AppTextFormField(
              isNumber: true,
              controller: zipcodeController,
              labelText: context.localize('label_zipcode'),
              hintText: context.localize('place_holder_zipcode'),
            ),
          ),
          // Padding(
          //   padding:
          //       const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
          //   child: CSCPicker(
          //     layout: Layout.vertical,
          //     showCities: true,
          //     showStates: true,
          //     flagState: CountryFlag.DISABLE,
          //     countrySearchPlaceholder: context.localize('label_country'),
          //     stateSearchPlaceholder: context.localize('label_city'),
          //     citySearchPlaceholder: context.localize('label_district'),
          //     countryDropdownLabel: context.localize('place_holder_country'),
          //     stateDropdownLabel: context.localize('place_holder_city'),
          //     cityDropdownLabel: context.localize('place_holder_district'),
          //     countryFilter: [CscCountry.Vietnam, CscCountry.United_States],
          //     dropdownItemStyle: GoogleFonts.nunitoSans(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w600,
          //       color: AppColor.black,
          //     ),
          //     onCountryChanged: (value) {
          //       setState(() {
          //         countryValue = value;
          //       });
          //     },
          //     onStateChanged: (value) {
          //       setState(() {
          //         cityValue = value;
          //       });
          //     },
          //     onCityChanged: (value) {
          //       setState(() {
          //         districtValue = value;
          //       });
          //     },
          //   ),
          // ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: AppTextFormField(
              isNumber: false,
              controller: countryController,
              labelText: context.localize('label_country'),
              hintText: context.localize('place_holder_country'),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: AppTextFormField(
              isNumber: false,
              controller: cityController,
              labelText: context.localize('label_city'),
              hintText: context.localize('place_holder_city'),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: AppTextFormField(
              isNumber: false,
              controller: districtController,
              labelText: context.localize('label_district'),
              hintText: context.localize('place_holder_district'),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: AppTextFormField(
              isNumber: false,
              controller: placeController,
              labelText: context.localize('label_place'),
              hintText: context.localize('place_holder_place'),
            ),
          ),
          Text(
            errorMessage ?? '',
            style: TextStyle(color: Colors.red),
          ),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: ActionButton(
                  boxShadow: [],
                  content: Text(
                    context.localize('label_pick_a_location'),
                    style: AppStyle.text_style_on_black_button,
                  ),
                  size: Size(double.infinity, 60),
                  color: AppColor.grey,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PickLocation(
                                  onSubmit: (address) {
                                    countryController.text =
                                        address.country ?? '';
                                    cityController.text = address.city ?? '';
                                    districtController.text =
                                        address.district ?? '';
                                    streetController.text =
                                        address.street ?? '';
                                    zipcodeController.text =
                                        address.zipCode ?? '';
                                    placeController.text = address.place ?? '';
                                    latitude = address.latitude;
                                    longitude = address.longitude;
                                  },
                                )));
                  })),
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 35),
              child: ActionButton(
                  boxShadow: [],
                  content: Text(
                    context.localize('label_save_button'),
                    style: AppStyle.text_style_on_black_button,
                  ),
                  size: Size(double.infinity, 60),
                  color: AppColor.black,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newAddress = Address(
                        name: nameController.text,
                        street: streetController.text,
                        city: cityController.text,
                        place: placeController.text,
                        district: districtController.text,
                        zipCode: zipcodeController.text,
                        country: countryController.text,
                        latitude: latitude,
                        longitude: longitude,
                      );
                      widget.onTap.call(newAddress);
                      Navigator.pop(context);
                    }
                    // else {
                    //   if (cityValue != null &&
                    //       districtValue != null &&
                    //       countryValue != null) {
                    //     setState(() {
                    //       errorMessage =
                    //           context.localize('error_message_empty_address');
                    //     });
                    //   }
                    // }
                  })),
        ]),
      ),
    );
  }
}
