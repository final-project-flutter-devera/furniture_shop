import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Widgets/AppBarButton.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CupertinoSearchTextField(),
        elevation: 0,
        backgroundColor: AppColor.white,
        leading: const AppBarBackButtonPop(),
      ),
    );
  }
}
