// ignore_for_file: unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/src/pages/seller/store_page_bottom_navbar.dart';
import 'package:croshez/src/widgets/custom_margins.dart';
import 'package:croshez/src/widgets/popup.dart';
import 'package:croshez/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../helper/common_methods.dart';
import '../../../models/order_model.dart';
import '../../../utils/constants.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel order;
  final List products;
  const OrderDetails(this.order, this.products, {super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mybackbutton(),
          Padding(
            padding: cmargin(
              right: 28,
              left: 28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    orderNumber(),
                    orderTime(),
                  ],
                ),
                orderTimeRemaining(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    orderDetailsBox(),
                    // orderImage(),
                  ],
                ),
                SizedBox(
                  height: HelperMethods().getMyDynamicHeight(400),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: cmargin(top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textTitle(),
                          items(),
                          // items(),
                          // items(),
                          Divider(
                            thickness: 0.5,
                            color: ColorsConfig().kPrimaryLightColor,
                          ),
                          subTotalRow(),
                          shippingToCityRow(),
                          Divider(
                            thickness: 0.5,
                            color: ColorsConfig().kPrimaryLightColor,
                          ),
                          totalPaymentRow(),
                          shippingAddress(),
                        ],
                      ),
                    ),
                  ),
                ),
                markAsShippedButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mybackbutton() {
    return Padding(
      padding: cmargin(bottom: 16, left: 15, top: 60, right: 28),
      // child: const BackButton(
      //   color: Colors.black,
      // ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          Get.offAll(() => const StorePageBottomNavBar(
                selectedIndex: 1,
              ));
        },
      ),
    );
  }

  Widget orderNumber() {
    return Text(
      "Order #${widget.order.orderId}",
      style: GoogleFonts.inter(
        fontSize: HelperMethods().getMyDynamicFontSize(22),
        fontWeight: FontWeight.w500,
        color: ColorsConfig().fieldIndicatorTextFieldColor,
      ),
    );
  }

  Widget orderTime() {
    return Padding(
      padding: cmargin(top: 5),
      child: Text(
        DateFormat('MMM dd HH:mm z').format(widget.order.orderTime!.toDate()),
        style: GoogleFonts.inter(
          fontSize: HelperMethods().getMyDynamicFontSize(12),
          fontWeight: FontWeight.w500,
          color: ColorsConfig().descriptionTextColor,
        ),
      ),
    );
  }

  Widget orderTimeRemaining() {
    return Padding(
      padding: cmargin(top: 20, bottom: 20),
      child: widget.order.orderStatus == "Processing"
          ? getRemainingTime(widget.order.orderTime!)
          : Text(
              widget.order.orderStatus!,
              style: GoogleFonts.inter(
                fontSize: HelperMethods().getMyDynamicFontSize(16),
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(255, 0, 153, 153),
              ),
            ),
    );
  }

  Widget orderDetailsBox() {
    return Padding(
      padding: cmargin(bottom: 10),
      child: SizedBox(
        height: HelperMethods().getMyDynamicHeight(70),
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: HelperMethods().getMyDynamicWidth(220),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "Buyer: ",
                        style: GoogleFonts.inter(
                          fontSize: HelperMethods().getMyDynamicFontSize(16),
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                        // textAlign: TextAlign.left,
                      ),
                      TextSpan(
                        text: widget.order.buyerName,
                        style: GoogleFonts.inter(
                            fontSize: HelperMethods().getMyDynamicFontSize(16),
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 0, 153, 153)),
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   width: HelperMethods().getMyDynamicWidth(220),
              //   child: RichText(
              //     text: TextSpan(
              //       children: <TextSpan>[
              //         TextSpan(
              //           text: "Item: ",
              //           style: GoogleFonts.inter(
              //             fontSize: HelperMethods().getMyDynamicFontSize(16),
              //             fontWeight: FontWeight.w300,
              //             color: Colors.black,
              //           ),
              //           // textAlign: TextAlign.left,
              //         ),
              //         TextSpan(
              //           text: "Baby Yoda Crocheted",
              //           style: GoogleFonts.inter(
              //               fontSize: HelperMethods().getMyDynamicFontSize(16),
              //               fontWeight: FontWeight.w500,
              //               color: Color.fromARGB(255, 0, 153, 153)),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                width: HelperMethods().getMyDynamicWidth(220),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "Payment Status: ",
                        style: GoogleFonts.inter(
                          fontSize: HelperMethods().getMyDynamicFontSize(16),
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: widget.order.paymentStatus,
                        style: GoogleFonts.inter(
                            fontSize: HelperMethods().getMyDynamicFontSize(16),
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 0, 153, 153)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: HelperMethods().getMyDynamicWidth(220),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "Order Status: ",
                        style: GoogleFonts.inter(
                          fontSize: HelperMethods().getMyDynamicFontSize(16),
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                        // textAlign: TextAlign.left,
                      ),
                      TextSpan(
                        text: widget.order.orderStatus,
                        style: GoogleFonts.inter(
                            fontSize: HelperMethods().getMyDynamicFontSize(16),
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 0, 153, 153)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textTitle() {
    return Padding(
      padding: cmargin(top: 0, bottom: 0),
      child: Text(
        "Item (s)",
        style: GoogleFonts.inter(
          fontSize: HelperMethods().getMyDynamicFontSize(16),
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget items() {
    return ListView.separated(
        // order list
        separatorBuilder: (BuildContext context, int index) => new SizedBox(
              height: HelperMethods().getMyDynamicHeight(10),
            ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          Map prodRow = {
            "productId": widget.products[index]["productId"],
            "productName": widget.products[index]["productName"],
            "productImage": widget.products[index]["productImage"],
            "productPrice": widget.products[index]["productPrice"],
          };
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${index + 1}. ${prodRow['productName']}",
                style: GoogleFonts.inter(
                  fontSize: HelperMethods().getMyDynamicFontSize(16),
                  fontWeight: FontWeight.w600,
                  color: ColorsConfig().kPrimaryColor,
                ),
              ),
              Text(
                "PKR ${prodRow['productPrice']}",
                style: GoogleFonts.inter(
                  fontSize: HelperMethods().getMyDynamicFontSize(16),
                  fontWeight: FontWeight.w600,
                  color: ColorsConfig().kPrimaryColor,
                ),
              )
            ],
          );
        });
  }

  Widget subTotalRow() {
    return Padding(
      padding: cmargin(
        top: 10,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Sub Total",
            style: GoogleFonts.inter(
              fontSize: HelperMethods().getMyDynamicFontSize(16),
              fontWeight: FontWeight.w400,
              color: ColorsConfig().descriptionTextColor,
            ),
          ),
          Text(
            "PKR ${widget.order.totalPrice}",
            style: GoogleFonts.inter(
              fontSize: HelperMethods().getMyDynamicFontSize(16),
              fontWeight: FontWeight.w400,
              color: ColorsConfig().headingColor,
            ),
          )
        ],
      ),
    );
  }

  Widget shippingToCityRow() {
    return Padding(
      padding: cmargin(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Shipping to Lahore",
            style: GoogleFonts.inter(
              fontSize: HelperMethods().getMyDynamicFontSize(16),
              fontWeight: FontWeight.w400,
              color: ColorsConfig().descriptionTextColor,
            ),
          ),
          Text(
            "PKR ${widget.order.shippingPrice}",
            style: GoogleFonts.inter(
              fontSize: HelperMethods().getMyDynamicFontSize(16),
              fontWeight: FontWeight.w400,
              color: ColorsConfig().headingColor,
            ),
          )
        ],
      ),
    );
  }

  Widget totalPaymentRow() {
    return Padding(
      padding: cmargin(top: 10, bottom: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total Payment",
            style: GoogleFonts.inter(
              fontSize: HelperMethods().getMyDynamicFontSize(16),
              fontWeight: FontWeight.w600,
              color: ColorsConfig().kPrimaryColor,
            ),
          ),
          Text(
            "PKR ${widget.order.totalPrice!}",
            style: GoogleFonts.inter(
              fontSize: HelperMethods().getMyDynamicFontSize(16),
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 0, 153, 153),
            ),
          )
        ],
      ),
    );
  }

  Widget shippingAddress() {
    List<String> address = widget.order.address!.split(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: cmargin(bottom: 8),
          child: Text(
            "Shipping Address: ",
            style: GoogleFonts.inter(
              fontSize: HelperMethods().getMyDynamicFontSize(16),
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ),
        Text(
          "${address[0]},",
          style: GoogleFonts.inter(
              fontSize: HelperMethods().getMyDynamicFontSize(16),
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 0, 153, 153),
              height: 1.75),
        ),
        Text(
          "${address[1]}, ",
          style: GoogleFonts.inter(
              fontSize: HelperMethods().getMyDynamicFontSize(16),
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 0, 153, 153),
              height: 1.75),
        ),
        Text(
          address[2],
          style: GoogleFonts.inter(
              fontSize: HelperMethods().getMyDynamicFontSize(16),
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 0, 153, 153),
              height: 1.75),
        ),
        // Text(
        //   "${address[3]}.",
        //   style: GoogleFonts.inter(
        //       fontSize: HelperMethods().getMyDynamicFontSize(16),
        //       fontWeight: FontWeight.w600,
        //       color: const Color.fromARGB(255, 0, 153, 153),
        //       height: 1.75),
        // )
      ],
    );
  }

  Widget markAsShippedButton() {
    bool pressed = false;
    return RoundedButton(
      marginTop: 60,
      marginLeft: 0,
      disabledButton: widget.order.orderStatus!.toLowerCase() != "processing",
      backgroundColor: ColorsConfig().kPrimaryColor,
      buttonText: pressed == true ? "Already Shipped" : "Mark as Shipped",
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyPopUpDialog(
              popupTitle: "Confirm Shipment",
              popupText:
                  "Are you sure you have shipped this order? Once confirmed, this action cannot be undone.",
              pressContinue: () async {
                pressed = true;
                setState(() {});
                bool isConnected = await Conn().connectivityResult();
                if (isConnected) {
                  var collection =
                      FirebaseFirestore.instance.collection('orders');

                  QuerySnapshot querySnapshot = await collection
                      .where('orderId', isEqualTo: widget.order.orderId)
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    var docId = querySnapshot.docs.first.id;
                    await FirebaseFirestore.instance
                        .collection("orders")
                        .doc(docId)
                        .update({"orderStatus": "Shipped"});
                  }
                  // String buyerFCMToken = await UserServices()
                  //     .getFCMTokenFromDb(widget.order.buyerId!);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                  widget.order.orderStatus = "Shipped";

                  Get.offAll(
                    OrderDetails(widget.order, widget.products),
                  );
                } else {
                  const snackBar = SnackBar(
                    content: Text('No Internet'),
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
                // setState(() {});
              },
              pressCancel: () {
                Navigator.pop(context);
              },
              continueText: "Yes, I have shipped it",
              cancelText: "Go Back",
            );
          },
        );
      },
    );
  }

  Widget getRemainingTime(Timestamp orderT) {
    final currentT = DateTime.now();
    Timestamp.fromMillisecondsSinceEpoch(1688201406 * 1000);

    // Timestamp test = Timestamp.fromMillisecondsSinceEpoch(1688201406 * 1000);

    // DateTime orderTimeDT = DateTime.fromMillisecondsSinceEpoch(orderT * 1000);
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
        fontSize: HelperMethods().getMyDynamicFontSize(16),
        fontWeight: FontWeight.w400,
        color: remainingTDays.isNegative
            ? Colors.red
            : const Color.fromARGB(255, 0, 153, 153),
      ),
      // textAlign: TextAlign.left,
    );
  }
}
