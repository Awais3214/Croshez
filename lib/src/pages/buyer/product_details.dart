import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/models/cart_model.dart';
import 'package:croshez/models/product_model.dart';
import 'package:croshez/src/widgets/custom_margins.dart';
import 'package:croshez/src/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../bloc/cart_bloc/cart_bloc_bloc.dart';
import '../../../helper/common_methods.dart';
import '../../../models/store_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/buyer_services.dart';
import '../../widgets/skeleton_loading.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;
  const ProductDetails(this.product, {super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isAddedToCart = false;
  StoreModel storeData = StoreModel();

  @override
  void initState() {
    isAddedToCart = checkIfAlreadyInCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          productImage(),
          productDetails(),
          // FutureBuilder<Widget>(
          //   future: productDetails(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(
          //         child: CircularProgressIndicator(
          //           color: ColorsConfig().kPrimaryColor,
          //         ),
          //       );
          //     } else {
          //       if (snapshot.hasError) {
          //         return Center(
          //           child: Text('Error: ${snapshot.error}'),
          //         );
          //       } else {
          //         return snapshot.data!;
          //       }
          //     }
          //   },
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myBackButton(),
              // myFavoriteButton(),
            ],
          ),
          addToCartButton(),
        ],
      ),
    );
  }

  bool checkIfAlreadyInCart() {
    // User user = FirebaseAuth.instance.currentUser!;
    // QuerySnapshot document = await FirebaseFirestore.instance
    //     .collection('cart')
    //     .where('productId', isEqualTo: widget.product.productId)
    //     .where('userId', isEqualTo: user.uid)
    //     .get();
    // if (document.docs.isEmpty) {
    //   return false;
    // } else {
    //   return true;
    // }
    CartBlocState state = context.read<CartBlocBloc>().state;
    if (state is CartBlocLoaded) {
      List<CartModel> cartItems = state.carModelList;
      if (cartItems.isNotEmpty) {
        for (int i = 0; i < cartItems.length; i++) {
          if (cartItems[i].productId == widget.product.productId) {
            return true;
          }
        }
        return false;
      } else {
        return false;
      }
    } else {
      return false;
    }
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
        // child: const BackButton(
        //   color: Colors.black,
        // ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
    );
  }

  Widget myFavoriteButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: HelperMethods().getMyDynamicHeight(35),
          right: HelperMethods().getMyDynamicWidth(28),
          bottom: HelperMethods().getMyDynamicHeight(10),
        ),
        child: Container(
          height: 36,
          width: 36,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              setState(() {
                widget.product.favorite = !widget.product.favorite!;
              });
              BuyerServices.updatefavorite(
                  widget.product.favorite, widget.product.productId);
            },
            icon: Icon(
              widget.product.favorite!
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              color: ColorsConfig().kPrimaryColor,
              size: 24,
            ),
            iconSize: 20,
            padding: const EdgeInsets.all(0),
            isSelected: widget.product.favorite,
          ),
        ),
      ),
    );
  }

  Widget productImage() {
    return CachedNetworkImage(
      imageUrl: (widget.product.productImage ?? []).isEmpty
          ? ''
          : widget.product.productImage!.first,
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          const Skeleton(),
      errorWidget: (context, url, error) => const Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget productDetails() {
    return SingleChildScrollView(
      child: Container(
        // margin: EdgeInsets.only(top: 320),
        height: HelperMethods().getMyDynamicHeight(430),
        margin: cmargin(top: 345, bottom: 100),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: cmargin(top: 28, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.product.productName!,
                      style: GoogleFonts.inter(
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
                    style: GoogleFonts.inter(
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
                    widget.product.productDescription!,
                    style: GoogleFonts.inter(
                        fontSize: HelperMethods().getMyDynamicFontSize(16),
                        fontWeight: FontWeight.w400,
                        color: ColorsConfig().descriptionTextColor,
                        height: 2),
                  ),
                  SizedBox(
                    height: HelperMethods().getMyDynamicHeight(24),
                  ),
                  FutureBuilder(
                    future: initializeStoreData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorsConfig().kPrimaryColor,
                          ),
                        );
                      } else {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "POSTED BY",
                                style: GoogleFonts.inter(
                                  fontSize:
                                      HelperMethods().getMyDynamicFontSize(14),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: HelperMethods().getMyDynamicHeight(17),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height:
                                        HelperMethods().getMyDynamicHeight(30),
                                    width:
                                        HelperMethods().getMyDynamicWidth(30),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          HelperMethods()
                                              .getMyDynamicHeight(50),
                                        ),
                                      ),
                                      child: storeData.imageUrl == null
                                          ? Image.asset(
                                              'assets/profile_avatar.png',
                                              fit: BoxFit.contain,
                                            )
                                          : Image.network(
                                              storeData.imageUrl!,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: cmargin(left: 17),
                                    child: Text(
                                      storeData.shopName ?? storeData.shopName!,
                                      style: GoogleFonts.inter(
                                        fontSize: HelperMethods()
                                            .getMyDynamicFontSize(16),
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        }
                      }
                    },
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

  Widget priceIndicator() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "Rs. ",
            style: GoogleFonts.inter(
                fontSize: HelperMethods().getMyDynamicFontSize(20),
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          TextSpan(
            text: widget.product.price,
            style: GoogleFonts.inter(
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
      width: HelperMethods().getMyDynamicWidth(103),
      decoration: const BoxDecoration(
        color: Color(0xFFBCBCBC),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: cmargin(
          left: 15,
          right: 15,
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Image.asset(
            'assets/hook_icon.png',
          ),
          Text(
            widget.product.hookSize!,
            style: GoogleFonts.inter(
              fontSize: HelperMethods().getMyDynamicFontSize(14),
              fontWeight: FontWeight.w400,
              color: ColorsConfig().descriptionTextColor,
            ),
          ),
        ]),
      ),
    );
  }

  Widget addToCartButton() {
    return Align(
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
            marginTop: 27,
            marginLeft: 0,
            buttonText: isAddedToCart ? "Already in Cart" : "Add to Cart",
            isLoading: false,
            onTap: () async {
              isAddedToCart = true;
              setState(() {});
              /* List<CartModel> carList = [];
              BlocBuilder<CartBlocBloc, CartBlocState>(
                builder: (context, state) {
                  if (state is CartBlocLoaded) {
                    carList = state.carModelList;
                  }
                  return Container();
                },
              ); */
              bool isConnected = await Conn().connectivityResult();
              if (isConnected) {
                String userId = FirebaseAuth.instance.currentUser!.uid;
                DocumentSnapshot storeCollection =
                    await FirebaseFirestore.instance
                        .collection('shop')
                        .doc(widget.product.shopId)
                        // .where('userId', isEqualTo: userId)
                        .get();
                StoreModel storeDocument =
                    StoreModel.fromMap(storeCollection.data());
                // .map((e) => StoreModel.fromMap(
                //       e.data(),
                //     ))
                // .toList();

                Map<String, dynamic> map = {
                  'price': widget.product.price,
                  'image': (widget.product.productImage ?? []).isEmpty
                      ? ''
                      : widget.product.productImage!.first,
                  'name': widget.product.productName,
                  'productId': widget.product.productId,
                  'storeId': widget.product.shopId,
                  'userId': userId,
                  'quantity': 1,
                  'storeName': storeDocument.shopName,
                };
                FirebaseFirestore.instance.collection('cart').add(map);

                /* carList.add(
                CartModel(
                  price: product.price,
                  image: product.productImage!.first,
                  name: product.productName,
                  productId: product.productID,
                  storeId: product.shopId,
                  userId: userId,
                  quantity: 1,
                  storeName: storeDocument.shopName,
                ),
              );
              context.read<CartBlocBloc>().add(CartLoadedEvent(carList)); */
                getCartData();
                // isAddedToCart = true;
                // setState(() {});
                // print('object');
              } else {
                const snackBar = SnackBar(content: Text('No Internet'));
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            },
            backgroundColor: isAddedToCart
                ? ColorsConfig().kPrimaryLightColor
                : ColorsConfig().kPrimaryColor,
            disabledButton: isAddedToCart,
          ),
        ),
      ),
    );
  }

  void getCartData() async {
    FirebaseFirestore collection = FirebaseFirestore.instance;
    CollectionReference cartCollection = collection.collection('cart');
    QuerySnapshot cartsList = await cartCollection
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<CartModel> cartProductsList = cartsList.docs
        .map((e) => CartModel.fromMap(
              e.data(),
            ))
        .toList();
    if (mounted) {
      context.read<CartBlocBloc>().add(CartLoadedEvent(cartProductsList));
    }
  }

  initializeStoreData() async {
    bool isConnected = await Conn().connectivityResult();
    if (isConnected) {
      StoreModel storeDetails;
      CollectionReference collection =
          FirebaseFirestore.instance.collection('shop');
      var list = await collection
          .where(FieldPath.documentId, isEqualTo: widget.product.shopId)
          .get();
      storeDetails = list.docs
          .map(
            (doc) => StoreModel.fromMap(
              doc.data(),
            ),
          )
          .toList()
          .first;

      storeDetails.storeId = list.docs.first.id;
      storeData = storeDetails;
      return storeDetails;
    } else {
      return StoreModel();
    }
  }
}
