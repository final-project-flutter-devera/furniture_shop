import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:furniture_shop/localization/app_localization.dart';

class DeleteAlertDialog {
  static void showAlertDialog(
      {required BuildContext context,
      required String title,
      required String content,
      required void Function() onYesPressed,
      required void Function() onNoPressed}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          _dialogAction(String title, void Function() ontap) {
            return CupertinoDialogAction(
              child: Text(
                title,
                style: TextStyle(color: AppColor.blue),
              ),
              onPressed: ontap,
            );
          }

          return CupertinoAlertDialog(
            title: Text(
              title,
              style: AppStyle.tab_title_text_style,
            ),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  context.localize('label_yes'),
                  style: TextStyle(
                      color: AppColor.red, fontWeight: FontWeight.bold),
                ),
                onPressed: onYesPressed,
              ),
              CupertinoDialogAction(
                child: Text(
                  context.localize('label_no'),
                  style: TextStyle(
                    color: AppColor.blue,
                  ),
                ),
                onPressed: onNoPressed,
              ),
            ],
          );
        });
  }
}
