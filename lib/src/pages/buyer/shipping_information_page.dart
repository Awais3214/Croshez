import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/bloc/address_bloc/address_bloc.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/models/address_model.dart';
import 'package:croshez/models/cart_model.dart';
import 'package:croshez/src/pages/buyer/payment_page.dart';
import 'package:croshez/src/widgets/custom_margins.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../helper/common_methods.dart';
import '../../../utils/constants.dart';
import 'add_new_adress_page.dart';

class ShippingInformationPage extends StatefulWidget {
  final Map<String, List<CartModel>> listOfSelectedProducts;

  const ShippingInformationPage(
      {Key? key, required this.listOfSelectedProducts})
      : super(key: key);

  @override
  State<ShippingInformationPage> createState() =>
      _ShippingInformationPageState();
}

class _ShippingInformationPageState extends State<ShippingInformationPage> {
  List<AddressModel> addressDetails = [];
  bool isAddressSelected = false;
  bool buttonLoading = false;
  int globalIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backArrowIcon(),
          pageHeaderText(),
          pageDescriptionText(),
          divider(topMargin: 24),
          BlocBuilder<AddressBloc, AddressState>(
            builder: (blocContext, state) {
              if (state is AddressLoadedState) {
                addressDetails = state.addressDetails;
                checkIfAddressSelected();
                return SizedBox(
                  height: isAddressSelected
                      ? HelperMethods().getMyDynamicHeight(380)
                      : HelperMethods().getMyDynamicHeight(460),
                  child: ListView.builder(
                    itemCount: addressDetails.length + 1,
                    itemBuilder: (context, index) {
                      if (index == addressDetails.length) {
                        return pageButtons(
                          onTap: () {
                            Get.off(
                              () => AddNewAddressPage(
                                route: 'Shipping',
                                listOfSelectedProducts:
                                    widget.listOfSelectedProducts,
                              ),
                            );
                          },
                          buttonText: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: ColorsConfig().kPrimaryColor,
                                size: HelperMethods().getMyDynamicHeight(20),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: HelperMethods().getMyDynamicWidth(8),
                                ),
                                child: Text(
                                  'Add New Address',
                                  style: TextStyle(
                                    color: ColorsConfig().kPrimaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: HelperMethods()
                                        .getMyDynamicFontSize(16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          borderColor: ColorsConfig().kPrimaryColor,
                          height: 57,
                          borderRadius: 11,
                        );
                      } else {
                        return addressDetailsContainer(index);
                      }
                    },
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  color: ColorsConfig().kPrimaryColor,
                ),
              );
            },
          ),
          BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              if (state is AddressLoadedState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: addressDetails.isEmpty,
                      child: divider(topMargin: 0),
                    ),
                    Visibility(
                      visible: !isAddressSelected,
                      child: divider(topMargin: 0),
                    ),
                    itemCountandTotalBill(),
                    Visibility(
                      visible: isAddressSelected,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: pageButtons(
                          onTap: () async {
                            saveInBackend();
                            Get.to(
                              () => PaymentPage(
                                listOfSelectedProducts:
                                    widget.listOfSelectedProducts,
                                city: addressDetails[globalIndex].city!,
                                streetAddress:
                                    addressDetails[globalIndex].streetAddress!,
                                country: 'Pakistan',
                              ),
                            );
                          },
                          backGroundColor: ColorsConfig().kPrimaryColor,
                          buttonText: buttonLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'Go to Payment',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: HelperMethods()
                                          .getMyDynamicFontSize(16),
                                    ),
                                  ),
                                ),
                          borderRadius: 8,
                          height: 48,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }

  Future saveInBackend() async {
    bool isConnected = await Conn().connectivityResult();
    if (isConnected) {
      setState(() {});
      var db = FirebaseFirestore.instance.collection("address");
      var docIdList = await db
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      for (var i = 0; i < docIdList.docs.length; i++) {
        if (i == globalIndex) {
          await db.doc(docIdList.docs[i].id).update({
            "isSelected": true,
          });
        } else {
          await db.doc(docIdList.docs[i].id).update({
            "isSelected": false,
          });
        }
      }
    } else {
      const snackBar = SnackBar(content: Text('No Internet'));
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Widget addressDetailsContainer(int index) {
    return BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
      if (state is AddressLoadedState) {
        addressDetails = state.addressDetails;
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (addressDetails[index].isSelected) {
              return;
            }
            for (var i = 0; i < addressDetails.length; i++) {
              if (i == index) {
                continue;
              }
              addressDetails[i].isSelected = false;
            }
            addressDetails[index].isSelected =
                !addressDetails[index].isSelected;
            if (addressDetails[index].isSelected) {
              isAddressSelected = true;
              globalIndex = index;
            } else {
              isAddressSelected = false;
            }
            setState(() {});
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(32.08),
                  left: HelperMethods().getMyDynamicWidth(29.08),
                ),
                child: addressDetails[index].isSelected
                    ? Image.asset('assets/radio_button_checked.png')
                    : Image.asset('assets/radio_button_unchecked.png'),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(24),
                  left: HelperMethods().getMyDynamicWidth(15.08),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      addressDetails[index].streetAddress!,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: HelperMethods().getMyDynamicFontSize(16),
                      ),
                    ),
                    Text(
                      addressDetails[index].city!,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: HelperMethods().getMyDynamicFontSize(16),
                        height: 1.6,
                      ),
                    ),
                    Text(
                      addressDetails[index].country!,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: HelperMethods().getMyDynamicFontSize(16),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }

  void checkIfAddressSelected() {
    if (addressDetails.isNotEmpty) {
      isAddressSelected = true;
      if (addressDetails.length == 1) {
        addressDetails[0].isSelected = true;
      }
    }
  }

  Widget itemCountandTotalBill() {
    int subTotalBill = 0;
    int itemCount = 0;
    for (var i = 0; i < widget.listOfSelectedProducts.entries.length; i++) {
      List<CartModel> temp =
          widget.listOfSelectedProducts.entries.toList()[i].value;
      for (var j = 0; j < temp.length; j++) {
        subTotalBill = subTotalBill + int.parse(temp[j].price!);
      }
    }
    for (var i = 0; i < widget.listOfSelectedProducts.entries.length; i++) {
      List<CartModel> temp =
          widget.listOfSelectedProducts.entries.toList()[i].value;
      for (var j = 0; j < temp.length; j++) {
        itemCount = itemCount + 1;
      }
    }
    return Visibility(
      visible: isAddressSelected,
      child: Column(
        children: [
          SizedBox(
            width: HelperMethods().getMyDynamicWidth(330),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: HelperMethods().getMyDynamicHeight(12),
                      ),
                      child: Text(
                        'Sub Total  ($itemCount Items)',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: HelperMethods().getMyDynamicFontSize(16),
                          color: ColorsConfig().descriptionTextColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: HelperMethods().getMyDynamicHeight(20),
                      ),
                      child: Text(
                        addressDetails.isEmpty
                            ? 'Shipping To [City])'
                            : 'Shipping To ${addressDetails[globalIndex].city!}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: HelperMethods().getMyDynamicFontSize(16),
                          color: ColorsConfig().descriptionTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: HelperMethods().getMyDynamicHeight(10),
                      ),
                      child: Text(
                        'PKR $subTotalBill',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: HelperMethods().getMyDynamicFontSize(16),
                          color: isAddressSelected
                              ? Colors.black
                              : ColorsConfig().kPrimaryColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: HelperMethods().getMyDynamicHeight(16),
                      ),
                      child: Text(
                        'PKR ${widget.listOfSelectedProducts.length * 150}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: HelperMethods().getMyDynamicFontSize(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          divider(topMargin: 18),
          widget.listOfSelectedProducts.entries.length > 1
              ? Container(
                  margin: cmargin(
                    top: 5,
                    left: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '*Products from multiple shops will cost saperate shipping price (${widget.listOfSelectedProducts.entries.length} x 150)',
                        style: GoogleFonts.inter(
                          fontSize: HelperMethods().getMyDynamicFontSize(10),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          Container(
            width: HelperMethods().getMyDynamicWidth(330),
            margin: EdgeInsets.only(top: HelperMethods().getMyDynamicWidth(14)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: HelperMethods().getMyDynamicFontSize(16),
                  ),
                ),
                Text(
                  'PKR ${(widget.listOfSelectedProducts.length * 150) + subTotalBill}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: HelperMethods().getMyDynamicFontSize(16),
                    color: ColorsConfig().kPrimaryColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget pageButtons(
      {Color borderColor = Colors.white,
      Color backGroundColor = Colors.white,
      required Widget buttonText,
      required double borderRadius,
      required double height,
      required Function? onTap}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        height: HelperMethods().getMyDynamicHeight(height),
        width: HelperMethods().getMyDynamicWidth(330),
        margin: EdgeInsets.only(
          top: HelperMethods().getMyDynamicHeight(32),
          left: HelperMethods().getMyDynamicWidth(29),
          right: HelperMethods().getMyDynamicWidth(30),
        ),
        decoration: BoxDecoration(
          color: backGroundColor,
          border: borderColor != Colors.white
              ? Border.all(
                  width: HelperMethods().getMyDynamicHeight(2),
                  color: borderColor,
                )
              : null,
          borderRadius: BorderRadius.circular(
            HelperMethods().getMyDynamicHeight(borderRadius),
          ),
        ),
        child: buttonText,
      ),
    );
  }

  Widget divider({required double topMargin}) {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(topMargin),
        left: HelperMethods().getMyDynamicWidth(28),
        right: HelperMethods().getMyDynamicWidth(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: HelperMethods().getMyDynamicHeight(0.5),
              color: ColorsConfig().kPrimaryLightColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget pageDescriptionText() {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(20),
        left: HelperMethods().getMyDynamicWidth(28),
      ),
      child: Text(
        'Select your address',
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
        top: HelperMethods().getMyDynamicHeight(40),
        left: HelperMethods().getMyDynamicWidth(28),
      ),
      child: Text(
        'Shipping Information',
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
        Get.back();
      },
      child: Container(
        margin: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(23),
          top: HelperMethods().getMyDynamicHeight(50),
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
