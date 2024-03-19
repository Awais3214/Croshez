import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/src/pages/seller/store_ready.dart';
import 'package:croshez/src/widgets/city_field.dart';
import 'package:croshez/utils/constants.dart';
import 'package:croshez/utils/my_shared_preferecnces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/common_methods.dart';
import '../../../models/user_model.dart';

class SetUpShopPage extends StatefulWidget {
  const SetUpShopPage({super.key});

  @override
  State<SetUpShopPage> createState() => _SetUpShopPageState();
}

class _SetUpShopPageState extends State<SetUpShopPage> {
  String header = 'Set Up Your Shop';
  String description =
      "Let's get your crochet store up and running! Start by providing some basic information about your shop.";
  String shopFieldIndicatorText = 'Shop Name';
  String shopNameFieldHintText = "Enter your shop's name";
  String shopDescriptionFieldHintText = "Write a description for your Store";
  String descriptionFieldIndicatorText = "Shop Description";
  String cityFieldHintText = "Select your city";
  String cityIndicatorText = "City";
  List<String> cities = <String>[
    'Lahore',
    'Multan',
    'Islamabad',
    'Faislabad',
    'Hyderabad',
    'Karachi'
  ];
  String userInputShopName = '';
  String userInputShopDescription = '';
  String? userInputShopcity;
  bool shopNameError = false;
  bool shopDescriptionError = false;
  bool shopCityError = false;
  bool isTapped = false;
  final _focusNodeShopName = FocusNode();
  final _focusNodeShopDesc = FocusNode();
  final _focusNodeShopCity = FocusNode();

  @override
  void initState() {
    MySharedPreferecne().saveShopSetupStage(1);
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
            backArrowIcon(),
            pageHeaderText(),
            descriptionText(),
            inputFieldIndicatorText(shopFieldIndicatorText, 43),
            shopNameField(),
            errorMessage(shopNameError),
            inputFieldIndicatorText(descriptionFieldIndicatorText, 24),
            shopDescriptionField(),
            errorMessage(shopDescriptionError),
            inputFieldIndicatorText(cityIndicatorText, 24),
            MyCityField(
              focusNodeShopCity: _focusNodeShopCity,
              cityFieldHintText: cityFieldHintText,
              shopCityError: shopCityError,
              onTap: () {
                shopCityError = false;
                setState(() {});
              },
              onChanged: (value) {
                userInputShopcity = value;
                setState(() {});
              },
              userInputShopcity: userInputShopcity,
            ),
            errorMessage(shopCityError),
            continueButton(),
          ],
        ),
      ),
    );
  }

  Widget errorMessage(bool errorCheck) {
    return Visibility(
      visible: errorCheck,
      child: Container(
        margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(4),
            left: HelperMethods().getMyDynamicWidth(35)),
        child: Text(
          'Required',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: HelperMethods().getMyDynamicFontSize(12),
            color: const Color(0xFFB3261E),
          ),
        ),
      ),
    );
  }

  Widget continueButton() {
    return GestureDetector(
      onTap: isTapped
          ? null
          : () async {
              isTapped = true;
              setState(() {});
              if (userInputShopName == '') {
                _focusNodeShopName.unfocus();
                shopNameError = true;
              } else if (userInputShopDescription == '') {
                _focusNodeShopDesc.unfocus();
                shopDescriptionError = true;
              } else if (userInputShopcity == null) {
                _focusNodeShopCity.unfocus();
                shopCityError = true;
              } else {
                bool isConnected = await Conn().connectivityResult();
                if (isConnected) {
                  createShopInstance();
                  Get.offAll(() => const StoreReadyPage());
                } else {
                  const snackBar = SnackBar(content: Text('No Internet'));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              }
              isTapped = false;
              setState(() {});
            },
      child: Container(
        height: HelperMethods().getMyDynamicHeight(48),
        width: HelperMethods().getMyDynamicWidth(330),
        margin: EdgeInsets.only(
          top: HelperMethods().getMyDynamicHeight(126),
          left: HelperMethods().getMyDynamicWidth(30),
        ),
        decoration: BoxDecoration(
          color: userInputShopName == ''
              ? ColorsConfig().kPrimaryLightColor
              : userInputShopDescription == ''
                  ? ColorsConfig().kPrimaryLightColor
                  : userInputShopcity == null
                      ? ColorsConfig().kPrimaryLightColor
                      : ColorsConfig().kPrimaryColor,
          borderRadius: BorderRadius.circular(
            HelperMethods().getMyDynamicHeight(6),
          ),
        ),
        child: Center(
          child: isTapped
              ? CircularProgressIndicator(
                  color: ColorsConfig().kPrimaryColor,
                )
              : Text(
                  'Continue',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: HelperMethods().getMyDynamicFontSize(16),
                      fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );
  }

  Widget shopDescriptionField() {
    return Container(
      width: HelperMethods().getMyDynamicWidth(330),
      height: HelperMethods().getMyDynamicHeight(110),
      margin: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(30),
        top: HelperMethods().getMyDynamicHeight(8),
      ),
      padding: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(16),
        bottom: HelperMethods().getMyDynamicHeight(6),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: _focusNodeShopDesc.hasFocus
              ? const Color(0xFF1A444D)
              : shopDescriptionError
                  ? const Color(0xFFB3261E)
                  : const Color(0xFFD9D9D9),
        ),
        borderRadius: BorderRadius.circular(
          HelperMethods().getMyDynamicHeight(8),
        ),
      ),
      child: TextField(
        focusNode: _focusNodeShopDesc,
        onTap: () {
          setState(() {
            shopDescriptionError = false;
          });
        },
        onChanged: (value) {
          setState(() {
            userInputShopDescription = value;
          });
        },
        maxLines: 5,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: shopDescriptionFieldHintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: HelperMethods().getMyDynamicFontSize(16),
            color: const Color(0xFF3D3D3D).withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget shopNameField() {
    return Container(
      width: HelperMethods().getMyDynamicWidth(330),
      height: HelperMethods().getMyDynamicHeight(52),
      margin: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(30),
        top: HelperMethods().getMyDynamicHeight(8),
      ),
      padding: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(16),
        bottom: HelperMethods().getMyDynamicHeight(6),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: _focusNodeShopName.hasFocus
              ? const Color(0xFF1A444D)
              : shopNameError
                  ? const Color(0xFFB3261E)
                  : const Color(0xFFD9D9D9),
        ),
        borderRadius: BorderRadius.circular(
          HelperMethods().getMyDynamicHeight(8),
        ),
      ),
      child: TextField(
        onTap: () {
          setState(() {
            shopNameError = false;
          });
        },
        focusNode: _focusNodeShopName,
        onChanged: (value) {
          setState(() {
            userInputShopName = value;
          });
        },
        style: const TextStyle(),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: shopNameFieldHintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: HelperMethods().getMyDynamicFontSize(16),
            color: const Color(0xff3D3D3D).withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget inputFieldIndicatorText(String indicatorText, double height) {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(height),
        left: HelperMethods().getMyDynamicWidth(30),
      ),
      child: Text(
        indicatorText,
        style: TextStyle(
          fontSize: HelperMethods().getMyDynamicFontSize(14),
          fontWeight: FontWeight.w500,
          color: const Color(0xff3D3D3D),
        ),
      ),
    );
  }

  Widget descriptionText() {
    return Container(
      margin: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(31),
          right: HelperMethods().getMyDynamicWidth(52),
          top: HelperMethods().getMyDynamicHeight(24)),
      child: Text(
        description,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: HelperMethods().getMyDynamicFontSize(16),
          color: const Color(0xff767676),
        ),
      ),
    );
  }

  Widget pageHeaderText() {
    return Container(
      margin: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(31),
          top: HelperMethods().getMyDynamicHeight(36)),
      child: Text(
        header,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: HelperMethods().getMyDynamicFontSize(24)),
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
          margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(59),
          ),
          width: HelperMethods().getMyDynamicWidth(300),
          child: const Divider(
            thickness: 3,
            color: Colors.black,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: HelperMethods().getMyDynamicHeight(59)),
          width: HelperMethods().getMyDynamicWidth(90),
          child: const Divider(
            thickness: 0.8,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  void createShopInstance() async {
    User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection("shop").doc().set({
      "userId": user.uid.trim(),
      "shopName": userInputShopName.trim(),
      "shopDescription": userInputShopDescription.trim(),
      "city": userInputShopcity!.trim(),
    });
    QuerySnapshot userDocument = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, isEqualTo: user.uid)
        .get();

    List<UserModel> userData = userDocument.docs
        .map((e) => UserModel.fromMap(
              e.data(),
            ))
        .toList();
    List<dynamic> role = userData[0].role!;
    if (!role.contains('Seller')) {
      role.add('Seller');
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({"role": role});
    }
  }
}
