import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Constants/Colors.dart';
import '../Widgets/ShowAlertDialog.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class SupplierOrderModel extends StatelessWidget {
  final dynamic order;

  const SupplierOrderModel({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    order['orderImage'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['orderName'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('x' + order['orderQuantity'].toString()),
                              Text('\$ ' +
                                  order['orderPrice'].toStringAsFixed(2))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 35,
                width: 100,
                decoration: BoxDecoration(color: AppColor.black),
                child: Center(
                  child: Text(
                    'Detail',
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColor.white),
                  ),
                ),
              ),
            ),
            order['cancelStatus'] == true
                ? Text(
                    'Canceled',
                    style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.red),
                  )
                : Text(
                    order['deliveryStatus'],
                  ),
          ],
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              constraints:
                  BoxConstraints(minHeight: 0, maxHeight: double.infinity),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColor.grey5,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name:    ' + order['cusName'],
                      style: GoogleFonts.nunito(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Phone:    ' + order['phone'],
                      style: GoogleFonts.nunito(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Email:    ' + order['email'],
                      style: GoogleFonts.nunito(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Address:    ' + order['address'],
                      style: GoogleFonts.nunito(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    order['cancelStatus'] == true
                        ? Row(
                            children: [
                              Text(
                                'Canceled date:    ',
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                (DateFormat('dd/MM/yyyy - HH:mm')
                                        .format(order['cancelDate'].toDate()))
                                    .toString(),
                                style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.red),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                'Payment Method:   ',
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                order['paymentStatus'],
                                style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.blue),
                              ),
                            ],
                          ),
                    order['cancelStatus'] == true
                        ? Row(
                            children: [
                              Text(
                                'Order status:    ',
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                'Cancel',
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.red,
                                ),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                'Delivery Status:   ',
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                order['deliveryStatus'],
                                style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.blue),
                              ),
                            ],
                          ),
                    Row(
                      children: [
                        Text(
                          'Order Date:   ',
                          style: GoogleFonts.nunito(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy - HH:mm')
                              .format(order['orderDate'].toDate())
                              .toString(),
                          style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColor.blue),
                        ),
                      ],
                    ),
                    order['deliveryStatus'] == 'Delivered'
                        ? Text('This order has been already delivered')
                        : Row(
                            children: [
                              Text(
                                'Change Delivery Status To:   ',
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              order['deliveryStatus'] == 'Preparing'
                                  ? TextButton(
                                      onPressed: () {
                                        var today = DateTime.now();
                                        DatePicker.showDatePicker(context,
                                            minTime: today
                                                .subtract(Duration(days: 1)),
                                            maxTime: DateTime.now().add(
                                              const Duration(days: 2),
                                            ), onConfirm: (date) async {
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(order['orderID'])
                                              .update({
                                            'deliveryStatus': 'Shipping',
                                            'deliveryDate': date,
                                          });
                                        });
                                      },
                                      child: Text('Shipping ?'),
                                    )
                                  : TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(order['orderID'])
                                            .update({
                                          'deliveryStatus': 'Delivered',
                                        });
                                      },
                                      child: Text('Delivered ?'),
                                    ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
