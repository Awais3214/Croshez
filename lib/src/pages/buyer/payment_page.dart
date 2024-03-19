import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/bloc/buyer_orders_page_bloc/buyer_orders_bloc_bloc.dart';
import 'package:croshez/bloc/user_details_bloc/user_bloc_bloc.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/helper/common_methods.dart';
import 'package:croshez/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../bloc/cart_bloc/cart_bloc_bloc.dart';
import '../../../models/cart_model.dart';
import '../../../models/order_model.dart';
import '../../../utils/constants.dart';
import 'order_confirmed.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    required this.listOfSelectedProducts,
    required this.city,
    required this.streetAddress,
    required this.country,
  });

  final Map<String, List<CartModel>> listOfSelectedProducts;
  final String city;
  final String streetAddress;
  final String country;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String paymentMethod = '';
  bool isLoading = false;
  DateTime orderTime = DateTime.now();
  List<CartModel> cartProductList = [];
  List<String> productPrices = [];
  List<CartModel> stateProducts = [];
  int subTotalBill = 0;

  @override
  void initState() {
    BlocBuilder<CartBlocBloc, CartBlocState>(
      builder: (context, state) {
        if (state is CartBlocLoaded) {
          stateProducts = state.carModelList;
        }
        return Container();
      },
    );
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
          divider(24),
          radioButtons(),
          billingCalculator(),
          confirmOrderButton(),
        ],
      ),
    );
  }

  Future deleteOrderedProductsFromFirebase() async {
    CollectionReference cartCollection =
        FirebaseFirestore.instance.collection('cart');
    User user = FirebaseAuth.instance.currentUser!;
    String docId;
    for (int i = 0; i < cartProductList.length; i++) {
      QuerySnapshot cartProductsToBeDeleted = await cartCollection
          .where('userId', isEqualTo: user.uid)
          .where('productId', isEqualTo: cartProductList[i].productId)
          .get();
      docId = cartProductsToBeDeleted.docs.first.id;
      await cartCollection.doc(docId).delete();
    }
  }

  Future deleteOrderedProductsFromCart() async {
    for (int i = 0; i < cartProductList.length; i++) {
      for (int j = 0; i < stateProducts.length; j++) {
        if (cartProductList[i].productId == stateProducts[j].productId) {
          stateProducts.removeAt(j);
          continue;
        }
      }
    }
    context.read<CartBlocBloc>().add(CartLoadedEvent(stateProducts));
  }

  Future createOrderInstance() async {
    bool isConnected = await Conn().connectivityResult();
    if (mounted) {
      if (isConnected) {
        setState(() {
          isLoading = true;
        });

        try {
          cartProductList = [];
          for (int i = 0; i < widget.listOfSelectedProducts.length; i++) {
            List<CartModel> temp =
                widget.listOfSelectedProducts.entries.toList()[i].value;
            for (int j = 0; j < temp.length; j++) {
              cartProductList.add(temp[j]);
            }
          }

          UserBlocState state = context.read<UserBlocBloc>().state;
          UserModel appUser = UserModel();

          if (state is LoadedUserDetails) {
            appUser = state.userDetails!;
          }

          FirebaseAuth auth = FirebaseAuth.instance;
          User user = auth.currentUser!;
          var ordersDocuments = FirebaseFirestore.instance.collection("orders");
          for (int i = 0;
              i < widget.listOfSelectedProducts.entries.length;
              i++) {
            subTotalBill = 0;
            List<Map> listOfProducts = [];
            for (int j = 0; j < cartProductList.length; j++) {
              if (widget.listOfSelectedProducts.isEmpty) {
                continue;
              }
              if (cartProductList[j].storeId ==
                  widget.listOfSelectedProducts.entries.toList()[i].key) {
                listOfProducts.add({
                  "productId": cartProductList[j].productId!,
                  "productName": cartProductList[j].name!,
                  "productImage": cartProductList[j].image!,
                  "productPrice": cartProductList[j].price!,
                });
                subTotalBill =
                    subTotalBill + int.parse(cartProductList[j].price!);
              }
            }
            int timestamp = DateTime.now().microsecondsSinceEpoch;
            // OrderModel value = OrderModel(
            //   address:
            //       "${widget.streetAddress}, ${widget.city}, ${widget.country}",
            //   orderStatus: "Processing",
            //   orderTime: Timestamp.fromDate(orderTime),
            //   paymentMethod: "Cash",
            //   paymentStatus: "Unpaid",
            //   products: listOfProducts,
            //   shippingPrice: 150,
            //   totalPrice: (150 + subTotalBill),
            //   store: {
            //     "storeId": cartProductList[i].storeId,
            //     "storeName": cartProductList[i].storeName,
            //   },
            //   buyerId: user.uid,
            //   buyerName: appUser.fullname,
            //   orderId: orderTime.millisecondsSinceEpoch,
            // );

            if (mounted) {
              BuyerOrdersBlocState buyerOrderState =
                  context.read<BuyerOrdersBlocBloc>().state;
              List<OrderModel> buyerOrdersList = [];
              if (buyerOrderState is LoadedOrderState) {
                buyerOrdersList = buyerOrderState.orderModelList;
              }
              context
                  .read<BuyerOrdersBlocBloc>()
                  .add(OrdersLoadedEvent(buyerOrdersList));
            }

            // if (mounted) {
            //   SellerOrdersPageState sellerOrderState =
            //       context.read<SellerOrdersPageBloc>().state;
            //   List<OrderModel> sellerOrdersList = [];
            //   if (sellerOrderState is SellerOrdersLoaded) {
            //     sellerOrdersList = sellerOrderState.orders;
            //     sellerOrdersList.add(value);
            //   }
            //   context
            //       .read<SellerOrdersPageBloc>()
            //       .add(SellerOrdersLoadedEvent(orders: sellerOrdersList));
            // }
            await ordersDocuments.add({
              "address":
                  "${widget.streetAddress}, ${widget.city}, ${widget.country}",
              "orderStatus": "Processing",
              "orderTime": orderTime,
              "paymentMehod": "Cash",
              "paymentStatus": "Unpaid",
              "products": listOfProducts,
              "shippingPrice": 150,
              "totalPrice": (150 + subTotalBill),
              "store": {
                "storeId": cartProductList[i].storeId,
                "storeName": cartProductList[i].storeName,
              },
              "buyerId": user.uid,
              "buyerName": appUser.fullname,
              "orderId": timestamp,
            });
          }
          deleteOrderedProductsFromCart();
          deleteOrderedProductsFromFirebase();
        } catch (e) {
          var snackBar = SnackBar(content: Text(e.toString()));
          if (mounted) {
            return ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        const snackBar = SnackBar(content: Text('No Internet'));
        if (mounted) {
          return ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }

  Widget confirmOrderButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () async {
          bool isConnected = await Conn().connectivityResult();
          if (isConnected) {
            await createOrderInstance();
            Get.offAll(
              () => const OrderConfirmedPage(),
            );
          } else {
            const snackBar = SnackBar(content: Text('No Internet'));
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        },
        child: Container(
          width: HelperMethods().getMyDynamicWidth(330),
          height: HelperMethods().getMyDynamicHeight(48),
          margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(30),
          ),
          decoration: BoxDecoration(
            color: ColorsConfig().kPrimaryColor,
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
                    'Confirm Order',
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

  Widget billingCalculator() {
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
    return Container(
      width: HelperMethods().getMyDynamicWidth(330),
      margin: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(28),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sub Total ($itemCount Item)',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: HelperMethods().getMyDynamicFontSize(16),
                      color: ColorsConfig().descriptionTextColor,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: HelperMethods().getMyDynamicHeight(20),
                    ),
                    child: Text(
                      'Shipping to ${widget.city}',
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
                    margin: const EdgeInsets.only(),
                    child: Text(
                      'PKR $subTotalBill',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: HelperMethods().getMyDynamicHeight(16),
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
                        fontSize: HelperMethods().getMyDynamicHeight(16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          divider(18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(14),
                ),
                child: Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: HelperMethods().getMyDynamicFontSize(16),
                    color: ColorsConfig().headingColor,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(12),
                ),
                child: Text(
                  'PKR ${(widget.listOfSelectedProducts.length * 150) + subTotalBill}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: HelperMethods().getMyDynamicHeight(16),
                    color: ColorsConfig().kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget radioButtons() {
    return SizedBox(
      height: HelperMethods().getMyDynamicHeight(380),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(32.08),
                  left: HelperMethods().getMyDynamicWidth(29.08),
                ),
                child: Image.asset('assets/radio_button_checked.png'),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: HelperMethods().getMyDynamicWidth(14),
                  top: HelperMethods().getMyDynamicHeight(24),
                ),
                child: Text(
                  'Cash on Delivery',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: HelperMethods().getMyDynamicFontSize(16),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(20.08),
                  left: HelperMethods().getMyDynamicWidth(29.08),
                ),
                child: Image.asset('assets/radio_button_unchecked.png'),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: HelperMethods().getMyDynamicWidth(14),
                  top: HelperMethods().getMyDynamicHeight(12),
                ),
                child: Text(
                  'Card [Currently Unavailable]',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: HelperMethods().getMyDynamicFontSize(16),
                    color: ColorsConfig().descriptionTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget divider(double topMargin) {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(topMargin),
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
        'Select your Payment Method',
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
        'Payment',
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
          left: HelperMethods().getMyDynamicWidth(31),
          top: HelperMethods().getMyDynamicHeight(83),
        ),
        child: const Icon(IconData(0xe092,
            fontFamily: 'MaterialIcons', matchTextDirection: true)),
      ),
    );
  }
}
