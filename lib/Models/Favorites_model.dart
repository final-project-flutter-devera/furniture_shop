import 'package:flutter/material.dart';
import 'package:furniture_shop/Providers/Favorites_Provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../Constants/Colors.dart';
import '../Providers/Cart_Provider.dart';
import '../Providers/Product_class.dart';
import '../Widgets/ShowAlertDialog.dart';

class FavoritesModel extends StatelessWidget {
  const FavoritesModel({
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                MyAlertDialog.showMyDialog(
                                  context: context,
                                  title: 'Remove this product',
                                  content: 'Are you sure?',
                                  tabNo: () {
                                    Navigator.pop(context);
                                  },
                                  tabYes: () {
                                    context
                                        .read<Favorites>()
                                        .removeProduct(product);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                                size: 20,
                              ),
                            ),
                            context.watch<Cart>().getItems.firstWhereOrNull(
                                            (element) =>
                                                element.documentID ==
                                                product.documentID) !=
                                        null ||
                                    product.availableQuantity == 0
                                ? const SizedBox()
                                : IconButton(
                                    onPressed: () {
                                      context.read<Cart>().addItems(
                                            product.name,
                                            product.price,
                                            1,
                                            product.availableQuantity,
                                            product.imageList,
                                            product.documentID,
                                            product.supplierID,
                                          );
                                    },
                                    icon: const Icon(
                                      Icons.local_mall,
                                      size: 20,
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
          ),
        ),
      ),
    );
  }
}
