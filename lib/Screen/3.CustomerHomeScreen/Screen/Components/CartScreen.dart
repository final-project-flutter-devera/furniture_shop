import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Providers/Cart_Provider.dart';
import 'package:furniture_shop/Widgets/AppBarButton.dart';
import 'package:furniture_shop/Widgets/AppBarTitle.dart';
import 'package:furniture_shop/Widgets/ShowAlertDialog.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Models/Cart_model.dart';
import '../../../2. Login - Signup/Login.dart';
import '../../../8.CheckOut/Check_Out_Screen.dart';
import '../CustomerHomeScreen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double wMQ = MediaQuery.of(context).size.width;
    double total = context.watch<Cart>().totalPrice;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: const AppBarBackButtonPop(),
        title: const AppBarTitle(label: 'Cart'),
        centerTitle: true,
        actions: [
          context.watch<Cart>().getItems.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    MyAlertDialog.showMyDialog(
                        context: context,
                        title: 'Clear Cart',
                        content: 'Are you sure clear all products?',
                        tabNo: () {
                          Navigator.pop(context);
                        },
                        tabYes: () {
                          context.read<Cart>().clearAllProduct();
                          Navigator.pop(context);
                        });
                  },
                  icon: const Icon(
                    Icons.delete_forever_outlined,
                    color: AppColor.black,
                    size: 24,
                  ),
                ),
        ],
      ),
      body: context.watch<Cart>().getItems.isNotEmpty
          ? const CartProduct()
          : CartProductEmpty(wMQ: wMQ),
      bottomSheet: total == 0.0
          ? null
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColor.black),
                  ),
                  Text(
                    '\$ ${total.toStringAsFixed(2)}',
                    style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColor.black),
                  ),
                ],
              ),
            ),
      extendBody: true,
      bottomNavigationBar: total == 0.0
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  height: 60,
                  color: AppColor.black,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckOutScreen()));
                  },
                  child: Text(
                    'Check Out',
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class CartProductEmpty extends StatelessWidget {
  const CartProductEmpty({
    super.key,
    required this.wMQ,
  });

  final double wMQ;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hey! Your cart is empty!',
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: MaterialButton(
              height: 50,
              minWidth: wMQ * 0.6,
              color: AppColor.black,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerHomeScreen(),
                  ),
                );
              },
              child: Text(
                'Continue shopping',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColor.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartProduct extends StatelessWidget {
  const CartProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ListView.builder(
          itemCount: cart.count,
          itemBuilder: (context, index) {
            final product = cart.getItems[index];
            return CartModel(product: product);
          },
        );
      },
    );
  }
}
