import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/src/pages/seller/setup_shop_screen.dart';
import 'package:croshez/utils/constants.dart';
import 'package:croshez/utils/my_shared_preferecnces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helper/common_methods.dart';

class VerifyAgePage extends StatefulWidget {
  const VerifyAgePage({super.key});

  @override
  State<VerifyAgePage> createState() => _VerifyAgePageState();
}

class _VerifyAgePageState extends State<VerifyAgePage> {
  DateTime? age;
  String header = 'Verify Your Age';
  String description =
      'To become a seller on Croshez, you must be at least 18 years old. Please enter your date of birth for verification.';
  String enterAgeText = 'Enter Your Age';
  late DateTime fieldPlaceHolder;
  String dateFieldPlaceHolder = '';
  int userEnteredMonth = 0;
  int userEnteredYear = 0;
  int userEnteredDay = 0;
  int difference = 0;
  bool ageFieldError = false;
  bool ageLimitError = false;
  bool isTapped = false;

  @override
  void initState() {
    fieldPlaceHolder = DateTime.now().toUtc();
    dateFieldPlaceHolder = DateFormat('MM/dd/yyyy').format(fieldPlaceHolder);
    MySharedPreferecne().saveShopSetupStage(0);
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
            ageFieldIndicatorText(),
            ageField(),
            errorMessage(ageFieldError, 'Required'),
            errorMessage(ageLimitError, 'Under Aged'),
            continueButton(),
          ],
        ),
      ),
    );
  }

  Widget errorMessage(bool errorCheck, String errorText) {
    return Visibility(
      visible: errorCheck,
      child: Container(
        margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(4),
            left: HelperMethods().getMyDynamicWidth(35)),
        child: Text(
          errorText,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: HelperMethods().getMyDynamicFontSize(12),
            color: const Color(0xFFB3261E),
          ),
        ),
      ),
    );
  }

  Widget ageField() {
    return GestureDetector(
      onTap: () {
        setState(() {
          ageFieldError = false;
          ageLimitError = false;
        });
        DatePicker.showDatePicker(
          context,
          initialDateTime: fieldPlaceHolder,
          maxDateTime: DateTime.now(),
          onChange: (dateTime, selectedIndex) {
            userEnteredYear = dateTime.year;
            userEnteredDay = dateTime.day;
            userEnteredMonth = dateTime.month;
            setState(() {});
          },
          onCancel: () {
            setState(() {
              dateFieldPlaceHolder =
                  DateFormat('MM/dd/yyyy').format(fieldPlaceHolder);
            });
          },
          onConfirm: (dateTime, selectedIndex) {
            setState(() {
              age = dateTime;
              difference = (DateTime.now().year) - dateTime.year;
              fieldPlaceHolder = DateTime(
                dateTime.year,
                dateTime.month,
                dateTime.day,
              );
              dateFieldPlaceHolder =
                  DateFormat('dd - MM - yyyy').format(fieldPlaceHolder);
            });
          },
          dateFormat: 'dd MM yyyy',
        );
      },
      child: Container(
        width: HelperMethods().getMyDynamicWidth(330),
        height: HelperMethods().getMyDynamicHeight(52),
        margin: EdgeInsets.only(
          top: HelperMethods().getMyDynamicHeight(8),
          left: HelperMethods().getMyDynamicWidth(30),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            HelperMethods().getMyDynamicHeight(8),
          ),
          border: Border.all(
            color: ageFieldError
                ? const Color(0xFFB3261E)
                : ageLimitError
                    ? const Color(0xFFB3261E)
                    : const Color(0xffD9D9D9),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: HelperMethods().getMyDynamicWidth(14),
              ),
              child: Icon(
                Icons.today,
                size: HelperMethods().getMyDynamicFontSize(24),
                color: const Color(0xFF9E9E9E),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: HelperMethods().getMyDynamicWidth(16),
                top: HelperMethods().getMyDynamicHeight(16),
              ),
              child: Text(
                dateFieldPlaceHolder,
                style: TextStyle(
                  color: age == null ? const Color(0xFF9E9E9E) : Colors.black,
                  fontSize: HelperMethods().getMyDynamicFontSize(16),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
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
              if (age == null) {
                ageFieldError = true;
              } else if (difference < 18) {
                ageLimitError = true;
              } else {
                bool isConnected = await Conn().connectivityResult();
                if (isConnected) {
                  dbAddAgeField();
                  Get.to(
                    () => const SetUpShopPage(),
                  );
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
            top: HelperMethods().getMyDynamicHeight(80),
            left: HelperMethods().getMyDynamicWidth(30)),
        decoration: BoxDecoration(
            color: age == null
                ? ColorsConfig().kPrimaryLightColor
                : difference < 18
                    ? ColorsConfig().kPrimaryLightColor
                    : ageFieldError
                        ? ColorsConfig().kPrimaryLightColor
                        : ageLimitError
                            ? ColorsConfig().kPrimaryLightColor
                            : ColorsConfig().kPrimaryColor,
            borderRadius:
                BorderRadius.circular(HelperMethods().getMyDynamicHeight(6))),
        child: Center(
          child: Text(
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

  void dbAddAgeField() async {
    final auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update({"age": age})
        .then((document) {})
        .catchError((_) {});
  }

  Widget ageFieldIndicatorText() {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(40),
        left: HelperMethods().getMyDynamicWidth(30),
      ),
      child: Text(
        enterAgeText,
        style: TextStyle(
            fontSize: HelperMethods().getMyDynamicFontSize(14),
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget descriptionText() {
    return Container(
      margin: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(31),
          right: HelperMethods().getMyDynamicWidth(52),
          top: HelperMethods().getMyDynamicHeight(36)),
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
          margin: EdgeInsets.only(top: HelperMethods().getMyDynamicHeight(59)),
          width: HelperMethods().getMyDynamicWidth(250),
          child: const Divider(
            thickness: 3,
            color: Colors.black,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: HelperMethods().getMyDynamicHeight(59)),
          width: HelperMethods().getMyDynamicWidth(140),
          child: const Divider(
            thickness: 0.8,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
