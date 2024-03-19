import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/bloc/address_bloc/address_bloc.dart';
import 'package:croshez/src/pages/buyer/add_new_adress_page.dart';
import 'package:croshez/src/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../helper/common_methods.dart';
import '../../../models/address_model.dart';
import '../../../utils/constants.dart';

class ManageAddressesPage extends StatefulWidget {
  const ManageAddressesPage({super.key});

  @override
  State<ManageAddressesPage> createState() => _ManageAddressesPageState();
}

class _ManageAddressesPageState extends State<ManageAddressesPage> {
  List<AddressModel> addressDetails = [];

  @override
  Widget build(BuildContext context) {
    AddressState state = context.read<AddressBloc>().state;
    if (state is AddressLoadedState) {
      addressDetails = state.addressDetails;
    }
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backArrowIcon(),
          pageHeaderText(),
          pageDescriptionText(),
          divider(topMargin: 24),
          SizedBox(
            height: HelperMethods().getMyDynamicHeight(605),
            child: ListView.builder(
              itemCount: addressDetails.length,
              itemBuilder: (context, index) {
                return addressDetailsContainer(index, addressDetails);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: RoundedButton(
          buttonText: 'Create New Address',
          onTap: () {
            Get.off(
              () => const AddNewAddressPage(
                route: 'Manage',
              ),
            );
          },
          marginTop: 30,
          marginLeft: 30,
          backgroundColor: ColorsConfig().kPrimaryColor,
        ),
      ),
    );
  }

  //  void _deleteFromCart(
  //     String productId, int index, List<CartModel> cartProductList) async {
  //   cartProductList.removeAt(index);
  //   context.read<CartBlocBloc>().add(CartLoadedEvent(cartProductList));
  //   var db = FirebaseFirestore.instance.collection('cart');
  //   var cartItemList = await db
  //       .where(
  //         "userId",
  //         isEqualTo: FirebaseAuth.instance.currentUser!.uid,
  //       )
  //       .where("productId", isEqualTo: productId)
  //       .get();
  //   String docId = cartItemList.docs.first.id;
  //   await db.doc(docId).delete();
  // }

  Widget addressDetailsContainer(int index, List<AddressModel> addressDetails) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        if (state is AddressLoadedState) {
          return Container(
            margin: index == (addressDetails.length - 1)
                ? EdgeInsets.only(
                    top: HelperMethods().getMyDynamicHeight(24),
                    left: HelperMethods().getMyDynamicWidth(30),
                    right: HelperMethods().getMyDynamicWidth(30),
                    bottom: HelperMethods().getMyDynamicHeight(90),
                  )
                : EdgeInsets.only(
                    top: HelperMethods().getMyDynamicHeight(24),
                    left: HelperMethods().getMyDynamicWidth(30),
                    right: HelperMethods().getMyDynamicWidth(30),
                  ),
            width: HelperMethods().getMyDynamicWidth(300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Item'),
                          content: const Text(
                              'Are you sure you want to delete this address?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteAddress(index);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: SizedBox(
                    height: HelperMethods().getMyDynamicFontSize(24),
                    width: HelperMethods().getMyDynamicFontSize(24),
                    child: Image.asset(
                      'assets/delete-icon.png',
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void deleteAddress(int index) async {
    addressDetails.removeAt(index);
    setState(() {});
    context.read<AddressBloc>().add(AddressLoadedEvent(addressDetails));
    var db = FirebaseFirestore.instance.collection('address');
    var cartItemList = await db
        .where(
          "userId",
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get();
    String docId = cartItemList.docs.first.id;
    await db.doc(docId).delete();
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
        'Add or delete an address',
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
        'Manage Addresses',
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
          top: HelperMethods().getMyDynamicHeight(67),
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
