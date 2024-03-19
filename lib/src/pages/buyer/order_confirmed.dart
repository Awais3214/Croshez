import 'package:croshez/src/pages/buyer/buyer_home_bottom_navbar.dart';
import 'package:croshez/src/pages/buyer/buyer_orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../helper/common_methods.dart';
import '../../../utils/constants.dart';

class OrderConfirmedPage extends StatelessWidget {
  const OrderConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backArrowIcon(),
          pageImage(),
          pageHeaderText(),
          pageDescriptionText(),
          pageButtons(
            onTap: () {
              Get.offAll(
                () => const BuyerPageBottomNavBar(),
              );
              Get.to(
                () => const BuyerOrdersPage(),
              );
            },
            buttonText: 'Go to Orders',
            borderColor: ColorsConfig().borderColor,
          ),
          pageButtons(
            onTap: () {
              Get.offAll(
                () => const BuyerPageBottomNavBar(),
              );
            },
            buttonText: 'Explore More Items',
            backgroundColor: ColorsConfig().kPrimaryColor,
            textColor: Colors.white,
            topMargin: 16,
          )
        ],
      ),
    );
  }

  Widget pageButtons({
    required Function onTap,
    required String buttonText,
    double topMargin = 64,
    Color backgroundColor = Colors.white,
    Color borderColor = Colors.white,
    Color textColor = Colors.black,
  }) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          width: HelperMethods().getMyDynamicWidth(330),
          height: HelperMethods().getMyDynamicHeight(48),
          margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(topMargin),
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              HelperMethods().getMyDynamicHeight(8),
            ),
            border: borderColor == Colors.white
                ? null
                : Border.all(
                    color: borderColor,
                  ),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: HelperMethods().getMyDynamicFontSize(16),
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget pageDescriptionText() {
    return Container(
      width: HelperMethods().getMyDynamicWidth(316),
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(16),
        left: HelperMethods().getMyDynamicWidth(37),
      ),
      child: Text(
        "We're excited too! Your crochet finds are on their way to being yours. Stay updated with the progress of your order from the 'My Orders' section.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: HelperMethods().getMyDynamicFontSize(16),
          color: ColorsConfig().descriptionTextColor,
        ),
      ),
    );
  }

  Widget pageHeaderText() {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(34.44),
        left: HelperMethods().getMyDynamicWidth(43),
      ),
      child: Column(
        children: [
          Text(
            'Congratulations,',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: HelperMethods().getMyDynamicFontSize(24),
            ),
          ),
          Text(
            'Your Order is Processing!',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: HelperMethods().getMyDynamicFontSize(24),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget pageImage() {
    return Container(
      height: HelperMethods().getMyDynamicHeight(261.56),
      width: HelperMethods().getMyDynamicWidth(212.23),
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(22),
        left: HelperMethods().getMyDynamicWidth(102.89),
      ),
      child: SvgPicture.asset('assets/confirm_order_page_cat_icon.svg'),
    );
  }

  Widget backArrowIcon() {
    return GestureDetector(
      onTap: () {
        // print('object');
        Get.offAll(() => const BuyerPageBottomNavBar());
        // Get.back();
      },
      child: Container(
        margin: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(31),
          top: HelperMethods().getMyDynamicHeight(83),
        ),
        child: const Icon(IconData(0xe092,
            fontFamily: 'MaterialIcons', matchTextDirection: true)),
      ),
    );
  }
}
