import 'package:croshez/src/pages/seller/store_page_bottom_navbar.dart';
import 'package:croshez/src/pages/seller/upload_product_page.dart';
import 'package:croshez/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../helper/common_methods.dart';
import '../../../utils/my_shared_preferecnces.dart';

class StoreReadyPage extends StatefulWidget {
  const StoreReadyPage({super.key});

  @override
  State<StoreReadyPage> createState() => _StoreReadyPageState();
}

class _StoreReadyPageState extends State<StoreReadyPage> {
  String header1 = "Congratulations,";
  String header2 = "Your Store is Ready!";
  String description =
      "You've successfully set up your crochet store. You can now start adding your first product or jump right into exploring the app.";

  @override
  void initState() {
    MySharedPreferecne().saveShopSetupStage(2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            divider(),
            /* backArrowIcon(), */
            greyPictureBox(),
            pageHeaderText(),
            descriptionText(),
            addProducButton(),
            goToAppButton(),
          ],
        ),
      ),
    );
  }

  Widget goToAppButton() {
    return GestureDetector(
      onTap: () {
        Get.offAll(() => const StorePageBottomNavBar());
      },
      child: Container(
        height: HelperMethods().getMyDynamicHeight(48),
        width: HelperMethods().getMyDynamicWidth(330),
        margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(16),
            left: HelperMethods().getMyDynamicWidth(30)),
        decoration: BoxDecoration(
            color: ColorsConfig().kPrimaryColor,
            borderRadius:
                BorderRadius.circular(HelperMethods().getMyDynamicHeight(6))),
        child: Center(
          child: Text(
            'Go to the App',
            style: TextStyle(
                color: Colors.white,
                fontSize: HelperMethods().getMyDynamicFontSize(16),
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget addProducButton() {
    return GestureDetector(
      onTap: () {
        Get.offAll(() => const StorePageBottomNavBar());
        Get.to(() => const UploadProductPage());
      },
      child: Container(
        width: HelperMethods().getMyDynamicWidth(330),
        height: HelperMethods().getMyDynamicHeight(48),
        margin: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(30),
          top: HelperMethods().getMyDynamicHeight(56),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xffD9D9D9),
          ),
          borderRadius: BorderRadius.circular(
            HelperMethods().getMyDynamicHeight(8),
          ),
        ),
        child: Center(
          child: Text(
            'Add Your First Product',
            style: TextStyle(
              fontSize: HelperMethods().getMyDynamicFontSize(16),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget descriptionText() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(52),
            right: HelperMethods().getMyDynamicWidth(52),
            top: HelperMethods().getMyDynamicHeight(16)),
        child: Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: HelperMethods().getMyDynamicFontSize(16),
            color: const Color(0xff767676),
          ),
        ),
      ),
    );
  }

  Widget pageHeaderText() {
    return Container(
      width: HelperMethods().getMyDynamicWidth(247),
      height: HelperMethods().getMyDynamicHeight(76),
      margin: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(72),
        top: HelperMethods().getMyDynamicHeight(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            header1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: HelperMethods().getMyDynamicFontSize(24),
            ),
          ),
          Text(
            header2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: HelperMethods().getMyDynamicFontSize(24),
            ),
          ),
        ],
      ),
    );
  }

  Widget greyPictureBox() {
    return Center(
      child: Container(
        height: HelperMethods().getMyDynamicHeight(292),
        width: HelperMethods().getMyDynamicWidth(292),
        margin: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(16),
          top: HelperMethods().getMyDynamicHeight(59),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            HelperMethods().getMyDynamicHeight(6),
          ),
        ),
        child: SvgPicture.asset('assets/store_ready_cat_logo.svg'),
      ),
    );
  }

  Widget backArrowIcon() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        margin: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(27),
            top: HelperMethods().getMyDynamicHeight(20)),
        padding: EdgeInsets.symmetric(
            horizontal: HelperMethods().getMyDynamicWidth(4),
            vertical: HelperMethods().getMyDynamicHeight(4)),
        child: const Icon(IconData(0xe092,
            fontFamily: 'MaterialIcons', matchTextDirection: true)),
      ),
    );
  }

  Widget divider() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: HelperMethods().getMyDynamicHeight(59)),
          width: HelperMethods().getMyDynamicWidth(390),
          child: const Divider(
            thickness: 3,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
