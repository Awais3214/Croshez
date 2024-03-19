import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/bloc/address_bloc/address_bloc.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/models/address_model.dart';
import 'package:croshez/src/pages/buyer/manage_addresses_page.dart';
import 'package:croshez/src/pages/buyer/shipping_information_page.dart';
import 'package:croshez/src/widgets/city_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../helper/common_methods.dart';
import '../../../models/cart_model.dart';
import '../../../utils/constants.dart';

class AddNewAddressPage extends StatefulWidget {
  const AddNewAddressPage({super.key, this.route, this.listOfSelectedProducts});
  final String? route;
  final Map<String, List<CartModel>>? listOfSelectedProducts;

  @override
  State<AddNewAddressPage> createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  FocusNode addressLineFocusNode = FocusNode();
  FocusNode cityFieldFocusNode = FocusNode();
  FocusNode countryFieldFocusNode = FocusNode();
  bool addressLineError = false;
  bool cityFieldError = false;
  bool countryFieldError = false;
  bool isLoading = false;
  TextEditingController addressLineController = TextEditingController();
  String? cityFieldController;
  TextEditingController countryFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backArrowIcon(),
            pageHeaderText(),
            pageDescriptionText(),
            inputFieldIndicatorText('Address Line', 100),
            inputField(
              focusNode: addressLineFocusNode,
              errorCheck: addressLineError,
              onTap: () {
                addressLineError = false;
                setState(() {});
              },
              hintText: '',
              controller: addressLineController,
            ),
            errorMessage(addressLineError),
            inputFieldIndicatorText('City', 24),
            MyCityField(
              focusNodeShopCity: cityFieldFocusNode,
              cityFieldHintText: '',
              shopCityError: cityFieldError,
              userInputShopcity: cityFieldController,
              onTap: () {
                cityFieldError = false;
                setState(() {});
              },
              onChanged: (value) {
                cityFieldController = value;
                setState(() {});
              },
            ),
            errorMessage(cityFieldError),
            // inputFieldIndicatorText('Province', 24),
            // inputField(
            //   focusNode: provinceFieldFocusNode,
            //   errorCheck: provinceFieldError,
            //   onTap: () {
            //     provinceFieldError = false;
            //     setState(() {});
            //   },
            //   hintText: '',
            //   controller: provinceFieldController,
            // ),
            // errorMessage(provinceFieldError),
            inputFieldIndicatorText('Country', 24),
            inputField(
              focusNode: countryFieldFocusNode,
              errorCheck: countryFieldError,
              onTap: () {
                countryFieldError = false;
                setState(() {});
              },
              hintText: 'Pakistan',
              controller: countryFieldController,
              isCountryField: true,
            ),
            errorMessage(countryFieldError),
            addAddressButton(),
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

  Future createAddressInstance() async {
    bool isConnected = await Conn().connectivityResult();
    if (isConnected) {
      FirebaseAuth auth = FirebaseAuth.instance;
      User user = auth.currentUser!;
      await FirebaseFirestore.instance.collection("address").doc().set({
        "userId": user.uid.trim(),
        "streetAddress": addressLineController.text.trim(),
        "city": cityFieldController,
        "country": "Pakistan",
        "isSelected": false,
      });
      Map<String, dynamic> data = {
        "userId": user.uid.trim(),
        "streetAddress": addressLineController.text.trim(),
        "city": cityFieldController,
        "country": "Pakistan",
        "isSelected": false,
      };
      AddressModel newData = AddressModel.fromMap(data);
      if (mounted) {
        AddressState state = context.read<AddressBloc>().state;
        List<AddressModel> blocList = [];
        if (state is AddressLoadedState) {
          blocList = state.addressDetails;
          blocList.add(newData);
          context.read<AddressBloc>().add(AddressLoadedEvent(blocList));
        }
      }
    } else {
      const snackBar = SnackBar(content: Text('No Internet'));
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Widget addAddressButton() {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () async {
              if (addressLineController.text.trim().isEmpty) {
                addressLineFocusNode.unfocus();
                addressLineError = true;
              } else if (cityFieldController == null) {
                cityFieldFocusNode.unfocus();
                cityFieldError = true;
              } else {
                isLoading = true;
                setState(() {});
                await createAddressInstance();
                isLoading = false;
                widget.route == 'Shipping'
                    ? Get.off(
                        () => ShippingInformationPage(
                            listOfSelectedProducts:
                                widget.listOfSelectedProducts!),
                      )
                    : Get.off(
                        () => const ManageAddressesPage(),
                      );
              }
              isLoading = false;
              setState(() {});
            },
      child: Container(
        width: HelperMethods().getMyDynamicWidth(330),
        height: HelperMethods().getMyDynamicHeight(48),
        margin: EdgeInsets.only(
          top: HelperMethods().getMyDynamicHeight(145),
          left: HelperMethods().getMyDynamicWidth(30),
        ),
        decoration: BoxDecoration(
          color: addressLineController.text.trim().isEmpty
              ? ColorsConfig().kPrimaryLightColor
              : cityFieldController == null
                  ? ColorsConfig().kPrimaryLightColor
                  : ColorsConfig().kPrimaryColor,
          borderRadius: BorderRadius.circular(
            HelperMethods().getMyDynamicHeight(8),
          ),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  'Save Address',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: HelperMethods().getMyDynamicFontSize(16),
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget inputField({
    required String hintText,
    required TextEditingController controller,
    required bool errorCheck,
    required FocusNode focusNode,
    required Function? onTap,
    int maxLines = 1,
    double height = 52,
    double width = 330,
    double leftMargin = 31,
    isCountryField = false,
  }) {
    return Container(
      width: HelperMethods().getMyDynamicWidth(width),
      height: HelperMethods().getMyDynamicHeight(height),
      margin: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(leftMargin),
        top: HelperMethods().getMyDynamicHeight(8),
      ),
      padding: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(16),
        bottom: HelperMethods().getMyDynamicHeight(6),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: focusNode.hasFocus
              ? const Color(0xFF1A444D)
              : errorCheck
                  ? const Color(0xFFB3261E)
                  : const Color(0xFFD9D9D9),
        ),
        borderRadius: BorderRadius.circular(
          HelperMethods().getMyDynamicHeight(8),
        ),
      ),
      child: TextField(
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
        onTapOutside: (event) {
          focusNode.unfocus();
          setState(() {});
        },
        onSubmitted: (value) {
          setState(() {});
        },
        onChanged: (value) {
          setState(() {});
        },
        readOnly: isCountryField ? true : false,
        focusNode: focusNode,
        controller: controller,
        style: const TextStyle(),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: HelperMethods().getMyDynamicFontSize(16),
            color: ColorsConfig().headingColor,
          ),
        ),
      ),
    );
  }

  Widget inputFieldIndicatorText(String indicatorText, double topMargin) {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(topMargin),
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

  Widget pageDescriptionText() {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(24),
        left: HelperMethods().getMyDynamicWidth(28),
      ),
      child: Text(
        'Enter your details to add a new delivery destination.',
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: HelperMethods().getMyDynamicFontSize(16),
            color: ColorsConfig().descriptionTextColor),
      ),
    );
  }

  Widget pageHeaderText() {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(36),
        left: HelperMethods().getMyDynamicWidth(28),
      ),
      child: Text(
        'Add New Address',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: HelperMethods().getMyDynamicFontSize(24),
        ),
      ),
    );
  }

  Widget backArrowIcon() {
    return GestureDetector(
      onTap: () {
        widget.route == 'Shipping'
            ? Get.off(
                () => ShippingInformationPage(
                    listOfSelectedProducts: widget.listOfSelectedProducts!),
              )
            : Get.off(() => const ManageAddressesPage());
      },
      child: Container(
        margin: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(23),
          top: HelperMethods().getMyDynamicHeight(83),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: HelperMethods().getMyDynamicWidth(4),
            vertical: HelperMethods().getMyDynamicHeight(4)),
        child: const Icon(IconData(0xe092,
            fontFamily: 'MaterialIcons', matchTextDirection: true)),
      ),
    );
  }
}
