import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/bloc/buyer_home_page_bloc/products_bloc.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/helper/common_methods.dart';
import 'package:croshez/src/pages/buyer/shipping_information_page.dart';
import 'package:croshez/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../bloc/cart_bloc/cart_bloc_bloc.dart';
import '../../../models/cart_model.dart';
import '../../../utils/buyer_services.dart';
import '../../widgets/skeleton_loading.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  String descriptionText = 'Select The Items You Want to Purchase';
  List<String> productIdList = [];
  List<CartModel> selectedCartItems = [];
  List<CartModel> allCartProducts = [];
  int totalBill = 0;
  bool isLoading = true;
  Map<String, List<CartModel>> orderMap = {};

  @override
  void initState() {
    // getProductData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pageHeaderText(),
          pageDescriptionText(),
          divider(),
          cartProductsListBuilder(),
          BlocBuilder<CartBlocBloc, CartBlocState>(
            builder: (context, state) {
              List<CartModel> cartList = [];
              if (state is CartBlocLoaded) {
                cartList = state.carModelList;
                /* if (cartProductsList.isEmpty) {
                  cartProductsList = state.carModelList;
                } */
              }
              return Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: cartList
                      .where(
                        (element) => element.isSelected == true,
                      )
                      .toList()
                      .isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      divider(),
                      billCalculator(cartList),
                      goToShippingButton(cartList),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget billCalculator(List<CartModel> cartList) {
    int totalBillC = 0;
    for (var i = 0; i < cartList.length; i++) {
      if (cartList[i].isSelected) {
        totalBillC += int.tryParse(cartList[i].price!) ?? 0;
      }
    }

    int itemCount =
        cartList.where((element) => element.isSelected == true).toList().length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: HelperMethods().getMyDynamicHeight(12),
                left: HelperMethods().getMyDynamicWidth(28),
              ),
              child: Text(
                'Sub Total ($itemCount Items)',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: HelperMethods().getMyDynamicFontSize(16),
                  color: ColorsConfig().descriptionTextColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: HelperMethods().getMyDynamicWidth(30),
              ),
              child: Text(
                'PKR $totalBillC',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: HelperMethods().getMyDynamicFontSize(16),
                  color: ColorsConfig().kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(4),
            left: HelperMethods().getMyDynamicWidth(28),
          ),
          child: Text(
            '*Shipping to be calculated in the next step',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: HelperMethods().getMyDynamicFontSize(10),
              color: ColorsConfig().descriptionTextColor,
            ),
          ),
        )
      ],
    );
  }

  void orderMapAndSubTotalBill(List<CartModel> cartProductsList) {
    selectedCartItems = cartProductsList
        .where((element) => element.isSelected == true)
        .toList();

    orderMap = {};

    for (var i = 0; i < selectedCartItems.length; i++) {
      if (!orderMap.containsKey(selectedCartItems[i].storeId)) {
        orderMap[selectedCartItems[i].storeId!] = [];
      }
      orderMap[selectedCartItems[i].storeId]!.add(selectedCartItems[i]);
    }

    double subtotal = 0;
    for (var i = 0; i < orderMap.entries.length; i++) {
      List<CartModel> temp = orderMap.entries.toList()[i].value;
      for (var j = 0; j < temp.length; j++) {
        subtotal = subtotal + double.parse(temp[j].price!);
      }
    }
  }

  Widget goToShippingButton(List<CartModel> cartList) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          orderMapAndSubTotalBill(cartList);
          Get.to(
            () => ShippingInformationPage(
              listOfSelectedProducts: orderMap,
            ),
          );
        },
        child: Container(
          width: HelperMethods().getMyDynamicWidth(330),
          height: HelperMethods().getMyDynamicHeight(48),
          margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(14),
          ),
          decoration: BoxDecoration(
            color: ColorsConfig().kPrimaryColor,
            borderRadius: BorderRadius.circular(
              HelperMethods().getMyDynamicHeight(8),
            ),
          ),
          child: Center(
            child: Text(
              'Go To Shipping',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: HelperMethods().getMyDynamicFontSize(16),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cartProductsListBuilder() {
    return BlocBuilder<CartBlocBloc, CartBlocState>(
      builder: (context, state) {
        if (state is CartBlocLoading) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: ColorsConfig().kPrimaryColor,
              ),
            ),
          );
        } else if (state is CartBlocLoaded) {
          allCartProducts = state.carModelList;
          return Container(
            height: HelperMethods().getMyDynamicHeight(390),
            margin: EdgeInsets.only(
              left: HelperMethods().getMyDynamicWidth(28),
            ),
            child: RefreshIndicator(
              color: ColorsConfig().kPrimaryColor,
              onRefresh: () async {
                bool isConnected = await Conn().connectivityResult();
                if (isConnected) {
                  if (mounted) {
                    await BuyerServices().getCartData(context);
                  }
                  return;
                } else {
                  const snackBar = SnackBar(content: Text('No Internet'));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              child: ListView.builder(
                itemCount: state.carModelList.length,
                itemBuilder: (context, index) =>
                    cartItem(state.carModelList, index),
              ),
            ),
          );
        }
        if (state is CartBlocEmpty) {
          return emptyCartIconAndText(
              'Your Cart is Empty',
              'Explore The Marketplace To Fill It Up',
              Icons.shopping_cart_outlined);
        }
        if (state is NoInternetState) {
          const snackBar = SnackBar(content: Text('No Internet'));
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          return emptyCartIconAndText(
              'No Internet',
              'Check Your Internet Connection',
              Icons.signal_wifi_connected_no_internet_4);
        }
        return emptyCartIconAndText(
            'Your Cart is Empty',
            'Explore The Marketplace To Fill It Up',
            Icons.shopping_cart_outlined);
      },
    );
  }

  Widget cartItem(List<CartModel> cartProductsList, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (cartProductsList[index].isSelected) {
          cartProductsList[index].isSelected = false;
        } else {
          cartProductsList[index].isSelected = true;
        }

        context.read<CartBlocBloc>().add(CartLoadedEvent(cartProductsList));
      },
      child: Container(
        margin: EdgeInsets.only(
          top: index == 0
              ? HelperMethods().getMyDynamicHeight(24)
              : HelperMethods().getMyDynamicHeight(12.37),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: HelperMethods().getMyDynamicHeight(12),
              width: HelperMethods().getMyDynamicWidth(12),
              margin: EdgeInsets.only(
                top: HelperMethods().getMyDynamicHeight(38),
              ),
              color: cartProductsList[index].isSelected
                  ? ColorsConfig().kPrimaryColor
                  : ColorsConfig().kPrimaryLightColor,
              child: Center(
                child: Icon(
                  Icons.check,
                  size: HelperMethods().getMyDynamicFontSize(12),
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: HelperMethods().getMyDynamicHeight(87.63),
              width: HelperMethods().getMyDynamicWidth(102),
              margin: EdgeInsets.only(
                left: HelperMethods().getMyDynamicWidth(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  HelperMethods().getMyDynamicHeight(12),
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: cartProductsList[index].image!,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const Skeleton(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: HelperMethods().getMyDynamicWidth(150),
                  margin: EdgeInsets.only(
                    left: HelperMethods().getMyDynamicWidth(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          cartProductsList[index].name!,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: HelperMethods().getMyDynamicFontSize(14),
                          ),
                        ),
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
                                    'Are you sure you Want to remove this item from your cart?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteFromCart(
                                          cartProductsList[index].productId!,
                                          index,
                                          cartProductsList);
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
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: HelperMethods().getMyDynamicWidth(18),
                      top: HelperMethods().getMyDynamicHeight(8.4)),
                  child: Text(
                    cartProductsList[index].price!,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: HelperMethods().getMyDynamicFontSize(14),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _deleteFromCart(
      String productId, int index, List<CartModel> cartProductList) async {
    cartProductList.removeAt(index);
    context.read<CartBlocBloc>().add(CartLoadedEvent(cartProductList));
    var db = FirebaseFirestore.instance.collection('cart');
    var cartItemList = await db
        .where(
          "userId",
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .where("productId", isEqualTo: productId)
        .get();
    String docId = cartItemList.docs.first.id;
    await db.doc(docId).delete();
  }

  Widget emptyCartIconAndText(
      String header, String description, IconData icon) {
    return Row(
      children: [
        Container(
          height: HelperMethods().getMyDynamicHeight(36),
          width: HelperMethods().getMyDynamicWidth(36),
          margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(24),
            left: HelperMethods().getMyDynamicWidth(28),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: HelperMethods().getMyDynamicWidth(2),
              color: const Color(0xFF304674),
            ),
          ),
          child: Icon(
            icon,
            size: HelperMethods().getMyDynamicHeight(15),
            color: const Color(0xFF5F5F5F),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(13),
            top: HelperMethods().getMyDynamicHeight(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                header,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: HelperMethods().getMyDynamicFontSize(16),
                  color: const Color(0xFF24292E),
                ),
              ),
              SizedBox(
                height: HelperMethods().getMyDynamicHeight(6),
              ),
              Text(
                description,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: HelperMethods().getMyDynamicFontSize(14),
                  color: const Color(0xFF767676),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(24),
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
        descriptionText,
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
        top: HelperMethods().getMyDynamicHeight(79),
        left: HelperMethods().getMyDynamicWidth(28),
      ),
      child: BlocBuilder<CartBlocBloc, CartBlocState>(
        builder: (context, state) {
          return Text(
            state is CartBlocLoaded
                ? 'Cart (${state.carModelList.length})'
                : 'Cart',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: HelperMethods().getMyDynamicFontSize(24),
            ),
          );
        },
      ),
    );
  }
}
