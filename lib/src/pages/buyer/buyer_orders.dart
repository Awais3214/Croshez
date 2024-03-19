import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/bloc/buyer_orders_page_bloc/buyer_orders_bloc_bloc.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/utils/buyer_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../helper/common_methods.dart';
import '../../../models/order_model.dart';
import '../../../models/product_model.dart';
import '../../../utils/constants.dart';
import '../../widgets/custom_margins.dart';
import '../../widgets/popup.dart';
import '../../widgets/skeleton_loading.dart';

class BuyerOrdersPage extends StatefulWidget {
  const BuyerOrdersPage({super.key});

  @override
  State<BuyerOrdersPage> createState() => _BuyerOrdersPageState();
}

class _BuyerOrdersPageState extends State<BuyerOrdersPage> {
  List<ProductModel> productDetailsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(28),
          right: HelperMethods().getMyDynamicWidth(28),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: cmargin(
                  top: 50,
                ),
                child: const Icon(
                  IconData(0xe092,
                      fontFamily: 'MaterialIcons', matchTextDirection: true),
                ),
              ),
            ),
            Padding(
              padding: cmargin(top: 30, bottom: 20),
              child: Text(
                "My Orders",
                style: GoogleFonts.inter(
                  fontSize: HelperMethods().getMyDynamicFontSize(24),
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: cmargin(bottom: 24),
              child: Text(
                "View and Manage The Status of Your Orders",
                style: GoogleFonts.inter(
                    fontSize: HelperMethods().getMyDynamicFontSize(16),
                    fontWeight: FontWeight.w300,
                    color: ColorsConfig().hintTextColor),
                textAlign: TextAlign.left,
              ),
            ),
            Divider(
              thickness: 0.5,
              color: ColorsConfig().kPrimaryLightColor,
            ),
            Expanded(
              child: RefreshIndicator(
                color: ColorsConfig().kPrimaryColor,
                onRefresh: () async {
                  if (mounted) {
                    await BuyerServices().getOrderData(context);
                  }
                },
                child: ListView(
                  children: [
                    getOrderTiles(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getOrderTiles() {
    return BlocBuilder<BuyerOrdersBlocBloc, BuyerOrdersBlocState>(
      builder: (context, state) {
        if (state is LoadingOrderState) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorsConfig().kPrimaryColor,
            ),
          );
        }
        if (state is LoadedOrderState) {
          List<OrderModel> ordersList = state.orderModelList;
          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 0.5,
              color: ColorsConfig().kPrimaryLightColor,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ordersList.length,
            itemBuilder: (context, orderIndex) {
              return SizedBox(
                child: Column(
                  children: [
                    Padding(
                      padding: cmargin(top: 0, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order #${ordersList[orderIndex].orderId}",
                            style: GoogleFonts.inter(
                                fontSize:
                                    HelperMethods().getMyDynamicFontSize(12),
                                fontWeight: FontWeight.w500,
                                color: ColorsConfig().hintTextColor),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            DateFormat('MMM dd hh:mm').format(
                                ordersList[orderIndex].orderTime!.toDate()),
                            style: GoogleFonts.inter(
                                fontSize:
                                    HelperMethods().getMyDynamicFontSize(12),
                                fontWeight: FontWeight.w500,
                                color: ColorsConfig().hintTextColor),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: cmargin(bottom: 16.4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.store_mall_directory_outlined,
                            color: ColorsConfig().hintTextColor,
                          ),
                          SizedBox(
                            width: HelperMethods().getMyDynamicWidth(8),
                          ),
                          Text(
                            ordersList[orderIndex].store!['storeName'],
                            style: GoogleFonts.inter(
                                fontSize:
                                    HelperMethods().getMyDynamicFontSize(12),
                                fontWeight: FontWeight.w500,
                                color: ColorsConfig().hintTextColor),
                          ),
                        ],
                      ),
                    ),
                    ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                              height: HelperMethods().getMyDynamicHeight(10),
                            ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ordersList[orderIndex].products!.length,
                        itemBuilder: (context, index) {
                          Map productDetails =
                              ordersList[orderIndex].products![index];
                          return Row(
                            // product list
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: ClipRRect(
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(14),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            productDetails['productImage'],
                                        // 'assets/baby_yoda_placeholder.png',
                                        width: HelperMethods()
                                            .getMyDynamicWidth(90),
                                        height: HelperMethods()
                                            .getMyDynamicHeight(90),
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                const Skeleton(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                                Icons.broken_image_outlined),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    // color: Colors.grey,
                                    width:
                                        HelperMethods().getMyDynamicWidth(160),
                                    child: Padding(
                                      padding: cmargin(top: 5),
                                      child: Text(
                                        productDetails['productName'],
                                        style: GoogleFonts.inter(
                                            fontSize: HelperMethods()
                                                .getMyDynamicFontSize(14),
                                            fontWeight: FontWeight.w500,
                                            color: ColorsConfig().headingColor,
                                            height: 1),
                                        // textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: HelperMethods().getMyDynamicHeight(70),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "PKR ${productDetails['productPrice']}",
                                      style: GoogleFonts.inter(
                                        fontSize: HelperMethods()
                                            .getMyDynamicFontSize(14),
                                        fontWeight: FontWeight.w500,
                                        color:
                                            ColorsConfig().descriptionTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
                    ordersList[orderIndex].orderStatus == "Completed"
                        ? Padding(
                            padding: cmargin(top: 6.37, bottom: 4.4),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "Received",
                                style: GoogleFonts.inter(
                                  fontSize:
                                      HelperMethods().getMyDynamicFontSize(14),
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(255, 0, 153, 153),
                                  // decoration: TextDecoration.underline,
                                ),
                                // textAlign: TextAlign.right,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              if (ordersList[orderIndex]
                                      .orderStatus!
                                      .toLowerCase() !=
                                  'shipped') {
                                return;
                              }

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MyPopUpDialog(
                                      popupTitle: "Confirm Receipt",
                                      popupText:
                                          "Are you sure you have received this order? Once confirmed, this action cannot be undone.",
                                      pressContinue: () async {
                                        bool isConnected =
                                            await Conn().connectivityResult();
                                        if (isConnected) {
                                          var collection = FirebaseFirestore
                                              .instance
                                              .collection('orders');
                                          User user = FirebaseAuth
                                              .instance.currentUser!;
                                          QuerySnapshot querySnapshot =
                                              await collection
                                                  .where(
                                                      'orderId',
                                                      isEqualTo:
                                                          ordersList[orderIndex]
                                                              .orderId)
                                                  .where("buyerId",
                                                      isEqualTo: user.uid)
                                                  .get();

                                          if (querySnapshot.docs.isNotEmpty) {
                                            var docId =
                                                querySnapshot.docs.first.id;
                                            await FirebaseFirestore.instance
                                                .collection("orders")
                                                .doc(docId)
                                                .update({
                                              "orderStatus": "Completed"
                                            });
                                            ordersList[orderIndex].orderStatus =
                                                'Completed';
                                            setState(() {});
                                            if (mounted) {
                                              context
                                                  .read<BuyerOrdersBlocBloc>()
                                                  .add(
                                                    OrdersLoadedEvent(
                                                        ordersList),
                                                  );
                                            }
                                          }
                                          if (mounted) {
                                            Navigator.pop(context);
                                          }
                                        } else {
                                          const snackBar = SnackBar(
                                            content: Text('No Internet'),
                                          );
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        }
                                      },
                                      pressCancel: () {
                                        Navigator.pop(context);
                                      },
                                      continueText: "Yes, I have received it",
                                      cancelText: "Go Back",
                                    );
                                  });
                            },
                            child: Padding(
                              padding: cmargin(top: 6.37, bottom: 4.4),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  ordersList[orderIndex]
                                              .orderStatus!
                                              .toLowerCase() ==
                                          'shipped'
                                      ? "Mark As Received"
                                      : '',
                                  style: GoogleFonts.inter(
                                    fontSize: HelperMethods()
                                        .getMyDynamicFontSize(14),
                                    fontWeight: FontWeight.w500,
                                    color:
                                        const Color.fromARGB(255, 0, 153, 153),
                                    decoration: TextDecoration.underline,
                                  ),
                                  // textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Total(Including Shipping):  PKR ${ordersList[orderIndex].totalPrice}",
                        style: GoogleFonts.inter(
                            fontSize: HelperMethods().getMyDynamicFontSize(12),
                            fontWeight: FontWeight.w500,
                            color: ColorsConfig().headingColor),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
