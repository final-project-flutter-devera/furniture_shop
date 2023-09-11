import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:furniture_shop/Objects/address.dart';
import 'package:furniture_shop/Providers/user_provider.dart';
import 'package:furniture_shop/Screen/16.%20ProfileRoutes/MyShippingAddress/edit_shipping_address.dart';
import 'package:furniture_shop/Widgets/delete_alert_dialog.dart';
import 'package:furniture_shop/localization/app_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyShippingAddressCard extends StatefulWidget {
  final Address address;
  final int index;
  final ValueChanged<int> setAsDefaultOnTap;
  final ValueChanged<int> deleteAddressOnTap;
  final ValueChanged<Address> editAddressOnTap;

  MyShippingAddressCard(
      {super.key,
      required this.index,
      required this.address,
      required this.setAsDefaultOnTap,
      required this.deleteAddressOnTap,
      required this.editAddressOnTap});
  @override
  State<MyShippingAddressCard> createState() => _MyShippingAddressCardState();
}

class _MyShippingAddressCardState extends State<MyShippingAddressCard> {
  late bool isDefault;
  @override
  void initState() {
    isDefault = widget.address.isDefault!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                value: widget.address.isDefault,
                activeColor: AppColor.black,
                onChanged: ((value) => setState(() {
                      widget.setAsDefaultOnTap.call(widget.index);
                      isDefault = !isDefault;
                    }))),
            Text(
              context.localize('use_address'),
              style:
                  GoogleFonts.nunitoSans(fontSize: 18, color: AppColor.black),
            )
          ],
        ),
        Container(
          decoration: AppStyle.white_container_decoration,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 20, right: 15),
                  child: Row(children: [
                    Text(
                      widget.address.name,
                      style: GoogleFonts.nunitoSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black),
                    ),
                    const Spacer(),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditShippingAddress(
                                  address: widget.address,
                                  onTap: (Address newAddress) {
                                    widget.editAddressOnTap.call(newAddress);
                                  }),
                            ));
                      },
                      icon: Icon(
                        Icons.edit,
                        color: AppColor.black,
                        size: 24,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 20)),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        DeleteAlertDialog.showAlertDialog(
                          context: context,
                          title: context
                              .localize('alert_box_title_delete_address'),
                          content:
                              '${widget.address.zipCode}, ${widget.address.street}, ${widget.address.place}, ${widget.address.city}, ${widget.address.district}, ${widget.address.country}',
                          onNoPressed: () {
                            Navigator.pop(context);
                          },
                          onYesPressed: () {
                            widget.deleteAddressOnTap.call(widget.index);
                          },
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        color: AppColor.black,
                        size: 24,
                      ),
                    ),
                  ]),
                ),
                const Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Divider(
                    color: AppColor.blur_grey,
                    thickness: 3,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  child: Text(
                    '${widget.address.zipCode}, ${widget.address.street}, ${widget.address.place}, ${widget.address.city}, ${widget.address.district}, ${widget.address.country}',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.nunitoSans(
                        color: AppColor.text_secondary, fontSize: 14),
                  ),
                )
              ]),
        ),
      ],
    );
  }
}
