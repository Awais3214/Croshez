import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/bloc/seller_home_page_bloc/seller_home_page_bloc.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/models/product_model.dart';
import 'package:croshez/src/pages/seller/store_page_bottom_navbar.dart';
import 'package:croshez/src/widgets/custom_margins.dart';
import 'package:croshez/src/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../helper/common_methods.dart';
import '../../../utils/constants.dart';

class PreviewProductScreen extends StatefulWidget {
  const PreviewProductScreen({
    super.key,
    required this.imageUrl,
    required this.hookSize,
    required this.productDetails,
    required this.productName,
    required this.productPrice,
    required this.buttonText,
  });
  final List<String> imageUrl;
  final String productName;
  final String productPrice;
  final String hookSize;
  final String productDetails;
  final String buttonText;

  @override
  State<PreviewProductScreen> createState() => _PreviewProductScreenState();
}

class _PreviewProductScreenState extends State<PreviewProductScreen> {
  bool isLoading = false;
  String userShopDocumentId = '';
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: productImage(),
          ),
          Positioned(
            bottom: 0,
            child: productDetails(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myBackButton(),
            ],
          ),
          uploadButton(),
        ],
      ),
    );
  }

  static myBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: HelperMethods().getMyDynamicHeight(33),
          left: HelperMethods().getMyDynamicWidth(14),
          bottom: HelperMethods().getMyDynamicHeight(10),
        ),
        child: const BackButton(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget productImage() {
    if (widget.buttonText == '') {
      if (widget.imageUrl.length == 1) {
        return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: HelperMethods().getMyDynamicHeight(362),
            child: Image.network(
              widget.imageUrl[0],
              fit: BoxFit.fill,
            ));
      } else {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider(
            carouselController: carouselController,
            items: widget.imageUrl.map((e) {
              return Image.network(
                e,
                fit: BoxFit.fill,
              );
            }).toList(),
            options: CarouselOptions(
              viewportFraction: 1,
              height: HelperMethods().getMyDynamicHeight(362),
            ),
          ),
        );
      }
    } else {
      if (widget.imageUrl.length == 1) {
        return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: HelperMethods().getMyDynamicHeight(362),
            child: Image.file(
              File(widget.imageUrl[0]),
              fit: BoxFit.fill,
            ));
      } else {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider(
            carouselController: carouselController,
            items: widget.imageUrl.map((e) {
              return Image.file(
                File(e),
                fit: BoxFit.fill,
              );
            }).toList(),
            options: CarouselOptions(
              viewportFraction: 1,
              height: HelperMethods().getMyDynamicHeight(362),
            ),
          ),
        );
      }
    }
  }

  Widget productDetails() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          bottom: widget.buttonText == ''
              ? HelperMethods().getMyDynamicHeight(84)
              : 0,
        ),
        height: HelperMethods().getMyDynamicHeight(432),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: cmargin(top: 28, left: 28, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.productName,
                      style: TextStyle(
                        fontSize: HelperMethods().getMyDynamicFontSize(24),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: HelperMethods().getMyDynamicHeight(30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      priceIndicator(),
                      hookIndicator(),
                    ],
                  ),
                  SizedBox(
                    height: HelperMethods().getMyDynamicHeight(30),
                  ),
                  Divider(
                    color: ColorsConfig().kPrimaryColor,
                    height: 1,
                  ),
                  SizedBox(
                    height: HelperMethods().getMyDynamicHeight(30),
                  ),
                  // Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // children: [
                  Text(
                    "DETAIL",
                    style: TextStyle(
                      fontSize: HelperMethods().getMyDynamicFontSize(14),
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  //   ],
                  // ),
                  SizedBox(
                    height: HelperMethods().getMyDynamicHeight(20),
                  ),
                  Text(
                    widget.productDetails,
                    style: TextStyle(
                        fontSize: HelperMethods().getMyDynamicFontSize(16),
                        fontWeight: FontWeight.w400,
                        color: ColorsConfig().descriptionTextColor,
                        height: 2),
                  ),
                  SizedBox(
                    height: HelperMethods().getMyDynamicHeight(24),
                  ),

                  SizedBox(
                    height: HelperMethods().getMyDynamicHeight(12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getShopId() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    CollectionReference collection =
        FirebaseFirestore.instance.collection('shop');
    QuerySnapshot userId =
        await collection.where('userId', isEqualTo: user.uid).get();
    return userId.docs.first.id;
  }

  Future<void> createProductInstance() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    userShopDocumentId = await getShopId();
    File file;
    List<String> downloadedUrls = [];
    for (int i = 0; i < widget.imageUrl.length; i++) {
      file = File(widget.imageUrl[i]);
      var snapshot = await firebaseStorage
          .ref()
          .child('images/${user.uid} + ${DateTime.now().millisecond}')
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      downloadedUrls.add(downloadUrl);
    }
    if (mounted) {
      SellerHomePageState state = context.read<SellerHomePageBloc>().state;
      List<ProductModel> listOfProducts = [];
      if (state is StoreProductsLoaded) {
        listOfProducts = state.products!;

        ProductModel newData = ProductModel();
        newData.hookSize = widget.hookSize.trim();
        newData.price = widget.productPrice.trim();
        newData.productDescription = widget.productDetails.trim();
        newData.shopId = userShopDocumentId.trim();
        newData.userId = user.uid.trim();
        newData.productName = widget.productName.trim();
        newData.productImage = downloadedUrls;

        listOfProducts.add(newData);

        context
            .read<SellerHomePageBloc>()
            .add(StoreProductsLoadedEvent(products: listOfProducts));
      }
    }
    try {
      FirebaseFirestore.instance.collection("product").doc().set({
        "userId": user.uid.trim(),
        "shopId": userShopDocumentId.trim(),
        "productName": widget.productName.trim(),
        "productDescription": widget.productDetails.trim(),
        "price": widget.productPrice.trim(),
        "hookSize": widget.hookSize.trim(),
        "productImage": downloadedUrls,
        "favorite": false,
      });
    } catch (e) {
      const snackBar = SnackBar(content: Text('No Internet'));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Widget priceIndicator() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "Rs. ",
            style: TextStyle(
                fontSize: HelperMethods().getMyDynamicFontSize(20),
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          TextSpan(
            text: widget.productPrice,
            style: TextStyle(
                fontSize: HelperMethods().getMyDynamicFontSize(24),
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget hookIndicator() {
    return Container(
      height: HelperMethods().getMyDynamicHeight(32),
      width: HelperMethods().getMyDynamicWidth(97),
      decoration: const BoxDecoration(
        color: Color(0xFFBCBCBC),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: cmargin(
          left: 9,
          right: 9,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Image.asset(
            'assets/hook_icon.png',
          ),
          Container(
            margin: EdgeInsets.only(
              left: HelperMethods().getMyDynamicWidth(4.8),
            ),
            child: Text(
              widget.hookSize,
              style: TextStyle(
                fontSize: HelperMethods().getMyDynamicFontSize(14),
                fontWeight: FontWeight.w400,
                color: ColorsConfig().descriptionTextColor,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget uploadButton() {
    return Visibility(
      visible: widget.buttonText == '' ? false : true,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: HelperMethods().getMyDynamicHeight(105),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Align(
            alignment: Alignment.center,
            child: RoundedButton(
              marginTop: 36,
              marginLeft: 0,
              buttonText: "Upload",
              isLoading: isLoading,
              onTap: () async {
                isLoading = true;
                setState(() {});
                bool isConnected = await Conn().connectivityResult();
                if (isConnected) {
                  await createProductInstance();
                  Get.offAll(() => const StorePageBottomNavBar());
                } else {
                  const snackBar = SnackBar(content: Text('No Internet'));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
                isLoading = false;
              },
              backgroundColor: ColorsConfig().kPrimaryColor,
              disabledButton: isLoading,
            ),
          ),
        ),
      ),
    );
  }
}
