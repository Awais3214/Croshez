import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/bloc/seller_orders_page_bloc/seller_orders_page_bloc.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/src/widgets/custom_margins.dart';
import 'package:croshez/utils/seller_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../helper/common_methods.dart';
import '../../../models/order_model.dart';
import '../../../utils/constants.dart';
import '../../widgets/skeleton_loading.dart';
import 'order_details.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int numTotalOrders = 0;
  List<OrderModel> newOrdersList = [];
  List<OrderModel> oldOrdersList = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellerOrdersPageBloc, SellerOrdersPageState>(
      builder: (context, state) {
        if (state is SellerOrdersLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorsConfig().kPrimaryColor,
            ),
          );
        }
        if (state is SellerOrdersLoaded) {
          List<OrderModel> ordersList = state.orders;
          numTotalOrders = ordersList.length;
          newOrdersList.clear();
          oldOrdersList.clear();
          for (int i = 0; i < ordersList.length; i++) {
            if (ordersList[i].orderStatus!.toLowerCase() == "completed") {
              oldOrdersList.add(ordersList[i]);
            } else {
              newOrdersList.add(ordersList[i]);
            }
          }
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
                  Padding(
                    padding: cmargin(top: 70, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ordersTitle(),
                        viewInsights(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: cmargin(bottom: 24),
                    child: Text(
                      "Manage Customer Orders Here",
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
                        bool isConnected = await Conn().connectivityResult();
                        if (isConnected) {
                          if (mounted) {
                            context
                                .read<SellerOrdersPageBloc>()
                                .add(SellerOrdersLoadingEvent());
                            await SellerServices().getOrderData(context);
                            setState(() {});
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
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: HelperMethods().getMyDynamicHeight(10),
                            // bottom: HelperMethods().getMyDynamicHeight(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: newOrdersList.isNotEmpty,
                                child: ordersTypeTitle(
                                  "Ongoing Orders (${newOrdersList.length})",
                                  10,
                                ),
                              ),
                              Visibility(
                                visible: newOrdersList.isNotEmpty,
                                child: getOrderTiles(newOrdersList),
                              ),
                              Visibility(
                                visible: newOrdersList.isNotEmpty,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: HelperMethods().getMyDynamicHeight(20),
                                  ),
                                  child: Divider(
                                    thickness: 0.5,
                                    color: ColorsConfig().kPrimaryLightColor,
                                  ),
                                ),
                              ), // newOrders
                              ordersTypeTitle(
                                "Completed Orders (${oldOrdersList.length})",
                                20,
                              ),
                              getOrderTiles(oldOrdersList), //oldOrders
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is SellerOrdersEmpty) {
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.only(
                left: HelperMethods().getMyDynamicWidth(28),
                right: HelperMethods().getMyDynamicWidth(28),
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  bool isConnected = await Conn().connectivityResult();
                  if (isConnected) {
                    if (mounted) {
                      await SellerServices().getOrderData(context);
                    }
                  } else {
                    const snackBar = SnackBar(
                      content: Text('No Internet'),
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: HelperMethods().getMyDynamicHeight(750),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: cmargin(top: 70, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ordersTitle(),
                              viewInsights(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: cmargin(bottom: 24),
                          child: Text(
                            "Manage Customer Orders Here",
                            style: GoogleFonts.inter(
                                fontSize:
                                    HelperMethods().getMyDynamicFontSize(16),
                                fontWeight: FontWeight.w300,
                                color: ColorsConfig().hintTextColor),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          color: ColorsConfig().kPrimaryLightColor,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: HelperMethods().getMyDynamicHeight(36),
                              width: HelperMethods().getMyDynamicWidth(36),
                              margin: EdgeInsets.only(
                                top: HelperMethods().getMyDynamicHeight(24),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                  color: const Color(0xFF5F5F5F),
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(
                                  HelperMethods().getMyDynamicHeight(5),
                                ),
                                child: const Image(
                                  image: AssetImage(
                                      'assets/empty_products_icon.png'),
                                  color: Color.fromARGB(255, 49, 47, 47),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: HelperMethods().getMyDynamicWidth(13),
                                top: HelperMethods().getMyDynamicHeight(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'No Orders?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: HelperMethods()
                                          .getMyDynamicFontSize(16),
                                      color: const Color(0xFF24292E),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        HelperMethods().getMyDynamicHeight(6),
                                  ),
                                  Text(
                                    'Diversify Your Crochet Item Uploads',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: HelperMethods()
                                          .getMyDynamicFontSize(14),
                                      color: const Color(0xFF767676),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Text('Error Loading Orders');
        }
      },
    );
  }

  Widget ordersTitle() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "Orders ",
            style: GoogleFonts.inter(
              fontSize: HelperMethods().getMyDynamicFontSize(22),
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            // textAlign: TextAlign.left,
          ),
          TextSpan(
            text: "($numTotalOrders)",
            style: GoogleFonts.inter(
                fontSize: HelperMethods().getMyDynamicFontSize(18),
                fontWeight: FontWeight.w300,
                color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget viewInsights() {
    return Text(
      '',
      // "View Insights",
      style: GoogleFonts.inter(
          fontSize: HelperMethods().getMyDynamicFontSize(16),
          fontWeight: FontWeight.w500,
          color: const Color.fromARGB(255, 0, 153, 153)),
      textAlign: TextAlign.left,
    );
  }

  Widget getOrderTiles(List<OrderModel> orderList) {
    int orderListIndex;
    return SizedBox(
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(
          thickness: 0.5,
          color: ColorsConfig().kPrimaryLightColor,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          orderListIndex = index;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: cmargin(top: 10, bottom: 4.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order #${orderList[index].orderId}",
                      style: GoogleFonts.inter(
                          fontSize: HelperMethods().getMyDynamicFontSize(16.5),
                          fontWeight: FontWeight.w600,
                          color: ColorsConfig().headingColor),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Rs ${orderList[index].totalPrice}",
                      style: GoogleFonts.inter(
                          fontSize: HelperMethods().getMyDynamicFontSize(16.5),
                          fontWeight: FontWeight.w600,
                          color: ColorsConfig().headingColor),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: HelperMethods().getMyDynamicWidth(160),
                child: Padding(
                  padding: cmargin(bottom: 20),
                  child: Text(
                    DateFormat('MMM dd HH:mm z')
                        .format(orderList[index].orderTime!.toDate()),
                    style: GoogleFonts.inter(
                      fontSize: HelperMethods().getMyDynamicFontSize(12),
                      fontWeight: FontWeight.w500,
                      color: ColorsConfig().descriptionTextColor,
                    ),
                    // textAlign: TextAlign.left,
                  ),
                ),
              ),
              ListView.separated(
                // order list
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: HelperMethods().getMyDynamicHeight(10),
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderList[orderListIndex].products!.length,
                itemBuilder: (context, index) {
                  Map productList = orderList[orderListIndex].products![index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(14),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: productList['productImage'],
                              width: HelperMethods().getMyDynamicWidth(70),
                              height: HelperMethods().getMyDynamicHeight(70),
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      const Skeleton(),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: HelperMethods().getMyDynamicWidth(160),
                            child: Padding(
                              padding: cmargin(top: 5),
                              child: Text(
                                productList['productName'],
                                style: GoogleFonts.inter(
                                    fontSize: HelperMethods()
                                        .getMyDynamicFontSize(14),
                                    fontWeight: FontWeight.w500,
                                    color: ColorsConfig().headingColor,
                                    height: 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: HelperMethods().getMyDynamicHeight(70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rs. ${productList['productPrice']}",
                              style: GoogleFonts.inter(
                                fontSize:
                                    HelperMethods().getMyDynamicFontSize(16),
                                fontWeight: FontWeight.w500,
                                color: ColorsConfig().descriptionTextColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
              Padding(
                padding: cmargin(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: HelperMethods().getMyDynamicWidth(160),
                      child: orderList[index].orderStatus == "Processing"
                          ? getRemainingTime(orderList[index].orderTime!)
                          : Text(
                              orderList[index].orderStatus!,
                              style: GoogleFonts.inter(
                                fontSize:
                                    HelperMethods().getMyDynamicFontSize(16),
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(255, 0, 153, 153),
                              ),
                            ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.to(
                          () => OrderDetails(
                            orderList[index],
                            orderList[index].products!,
                          ),
                        );
                      },
                      child: Text(
                        "View Details",
                        style: GoogleFonts.inter(
                          fontSize: HelperMethods().getMyDynamicFontSize(12),
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 0, 153, 153),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget ordersTypeTitle(String typetitle, double topMargin) {
    return Padding(
      padding: cmargin(top: topMargin),
      child: Text(
        typetitle,
        style: GoogleFonts.inter(
            fontSize: HelperMethods().getMyDynamicFontSize(16),
            fontWeight: FontWeight.w300,
            color: ColorsConfig().hintTextColor),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget getRemainingTime(Timestamp orderT) {
    final currentT = DateTime.now();

    DateTime orderTimeDT = orderT.toDate();
    final maxTime = orderTimeDT.add(const Duration(days: 5));
    final remainingTDays = maxTime.difference(currentT).inDays;
    final remainingTHours = maxTime.difference(currentT).inHours % 24;

    // print(remainingTDays);
    return Text(
      // "Fulfill in 5d 17h",
      remainingTDays.isNegative
          ? "Overdue by ${remainingTDays * -1}d ${remainingTHours}h"
          : "Fulfill in ${remainingTDays}d ${remainingTHours}h",
      style: GoogleFonts.inter(
        fontSize: HelperMethods().getMyDynamicFontSize(12),
        fontWeight: FontWeight.w500,
        color: remainingTDays.isNegative
            ? Colors.red
            : const Color.fromARGB(255, 0, 153, 153),
      ),
      // textAlign: TextAlign.left,
    );
  }
}
