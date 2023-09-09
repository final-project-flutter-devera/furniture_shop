import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../Constants/Colors.dart';
import '../Providers/Cart_Provider.dart';
import '../Providers/Favorites_Provider.dart';
import '../Providers/Product_class.dart';
import '../Widgets/ShowAlertDialog.dart';

class CartModel extends StatelessWidget {
  const CartModel({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Card(
          elevation: 3,
          child: SizedBox(
            height: 120,
            width: 335,
            child: Row(
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Image.network(
                    product.imageList.first,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColor.grey,
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.attach_money,
                                      size: 16,
                                    ),
                                    Text(
                                      product.price.toStringAsFixed(2),
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: AppColor.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 140,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: AppColor.grey5,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: product.quantity == 1
                                            ? IconButton(
                                                onPressed: () {
                                                  showCupertinoModalPopup<void>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CupertinoActionSheet(
                                                      title: Text(
                                                        'Remove this product',
                                                        style:
                                                            GoogleFonts.nunito(
                                                                color: AppColor
                                                                    .black),
                                                      ),
                                                      message: Text(
                                                        'Are you sure?',
                                                        style:
                                                            GoogleFonts.nunito(
                                                                color: AppColor
                                                                    .black),
                                                      ),
                                                      actions: <CupertinoActionSheetAction>[
                                                        CupertinoActionSheetAction(
                                                          isDefaultAction: true,
                                                          onPressed: () async {
                                                            context.read<Favorites>().getFavoriteItems.firstWhereOrNull((element) =>
                                                                        element
                                                                            .documentID ==
                                                                        product
                                                                            .documentID) !=
                                                                    null
                                                                ? context
                                                                    .read<
                                                                        Cart>()
                                                                    .removeProduct(
                                                                        product)
                                                                : await context
                                                                    .read<
                                                                        Favorites>()
                                                                    .addFavoriteItems(
                                                                      product
                                                                          .name,
                                                                      product
                                                                          .price,
                                                                      1,
                                                                      product
                                                                          .availableQuantity,
                                                                      product
                                                                          .imageList,
                                                                      product
                                                                          .documentID,
                                                                      product
                                                                          .supplierID,
                                                                    );
                                                            (context)
                                                                .read<Cart>()
                                                                .removeProduct(
                                                                    product);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Move to favorites',
                                                            style: GoogleFonts
                                                                .nunito(
                                                                    color: AppColor
                                                                        .blue),
                                                          ),
                                                        ),
                                                        CupertinoActionSheetAction(
                                                          onPressed: () {
                                                            context
                                                                .read<Cart>()
                                                                .removeProduct(
                                                                    product);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Remove this product',
                                                            style: GoogleFonts
                                                                .nunito(
                                                                    color:
                                                                        AppColor
                                                                            .red),
                                                          ),
                                                        ),
                                                      ],
                                                      cancelButton: TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Cancel',
                                                          style: GoogleFonts
                                                              .nunito(
                                                                  color: AppColor
                                                                      .black),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.delete_forever,
                                                  size: 14,
                                                ),
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  context
                                                      .read<Cart>()
                                                      .decrementByOne(product);
                                                },
                                                icon: const Icon(
                                                  Icons.remove,
                                                  size: 14,
                                                ),
                                              ),
                                      ),
                                      Text(
                                        product.quantity.toString(),
                                        style: product.quantity ==
                                                product.availableQuantity
                                            ? GoogleFonts.nunito(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: AppColor.red)
                                            : GoogleFonts.nunito(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: AppColor.black,
                                              ),
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: AppColor.grey5,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: IconButton(
                                          onPressed: product.quantity ==
                                                  product.availableQuantity
                                              ? null
                                              : () {
                                                  context
                                                      .read<Cart>()
                                                      .increment(product);
                                                },
                                          icon: const Icon(
                                            Icons.add,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            MyAlertDialog.showMyDialog(
                              context: context,
                              title: 'Remove this product',
                              content: 'Are you sure?',
                              tabNo: () {
                                Navigator.pop(context);
                              },
                              tabYes: () {
                                context.read<Cart>().removeProduct(product);
                                Navigator.pop(context);
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
