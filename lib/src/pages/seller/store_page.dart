import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/bloc/seller_home_page_bloc/seller_home_page_bloc.dart';
import 'package:croshez/bloc/store_details_bloc/store_details_bloc_bloc.dart';
import 'package:croshez/helper/common_methods.dart';
import 'package:croshez/src/pages/seller/preview_product.dart';
import 'package:croshez/src/pages/seller/upload_product_page.dart';
import 'package:croshez/utils/seller_services.dart';
import 'package:croshez/src/widgets/skeleton_loading.dart';
import 'package:croshez/utils/constants.dart';
import 'package:croshez/utils/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../models/product_model.dart';
import '../../../models/store_model.dart';
import '../../../utils/my_shared_preferecnces.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  OverlayEntry? _overlayEntry;
  Offset? buttonPosition;
  String header = "Store Name";
  String description =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.";
  List<ProductModel>? productsList = [];
  StoreModel? storeDetails = StoreModel();
  // StoreModel storeDetails;
  bool isMenuOpen = false;
  List<Widget> dropDownMenuList = [
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: HelperMethods().getMyDynamicFontSize(24),
          width: HelperMethods().getMyDynamicFontSize(24),
          margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(8),
            left: HelperMethods().getMyDynamicWidth(5),
            bottom: HelperMethods().getMyDynamicHeight(8),
          ),
          child: Image.asset(
            'assets/delete-icon.png',
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(10),
            left: HelperMethods().getMyDynamicWidth(1),
            right: HelperMethods().getMyDynamicWidth(11),
          ),
          child: Text(
            'Delete Post',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: HelperMethods().getMyDynamicFontSize(14),
            ),
          ),
        ),
      ],
    )
  ];
  String fcmToken = '';

  @override
  void initState() {
    MySharedPreferecne().saveUserType('Seller');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            // fcmToken =
            //     await UserServices().getFCMTokenFromDb("hy2kjfb79NZW7GqRSyNg");
            if (isMenuOpen) {
              _overlayEntry!.remove();
              isMenuOpen = false;
              setState(() {});
            }
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 0.0,
                expandedHeight: 0.0,
                collapsedHeight: 0,
                elevation: 0,
                pinned: true,
                flexibleSpace: Container(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return profilePictureCircle();
                }, childCount: 1),
              ),
              SliverAppBar(
                backgroundColor: Colors.white,
                toolbarHeight: HelperMethods().getMyDynamicHeight(36),
                elevation: 0,
                floating: false,
                pinned: true,
                flexibleSpace: Container(
                  padding: EdgeInsets.only(
                    top: HelperMethods().getMyDynamicHeight(24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          storeName(),
                          storeCity(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return storeDescription();
                }, childCount: 1),
              ),
              SliverAppBar(
                backgroundColor: Colors.white,
                toolbarHeight: HelperMethods().getMyDynamicHeight(20),
                elevation: 0,
                floating: false,
                pinned: true,
                flexibleSpace: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    divider(),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return SizedBox(
                      height: HelperMethods().getMyDynamicHeight(452),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          latestPostsText(),
                          gridViewBuilder(),
                        ],
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          )),
      floatingActionButton: floatingActionButton(),
    );
  }

  Widget gridViewBuilder() {
    return BlocBuilder<SellerHomePageBloc, SellerHomePageState>(
      builder: (context, state) {
        if (state is StoreLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorsConfig().kPrimaryColor,
            ),
          );
        }
        if (state is StoreProductsLoaded) {
          productsList = state.products;
          return Expanded(
            child: RefreshIndicator(
              color: ColorsConfig().kPrimaryColor,
              onRefresh: () async {
                if (mounted) {
                  await SellerServices().getProductList(context);
                }
              },
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  left: HelperMethods().getMyDynamicWidth(27),
                  right: HelperMethods().getMyDynamicWidth(28),
                  bottom: HelperMethods().getMyDynamicHeight(80),
                  top: 0,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 161 / 200,
                  crossAxisSpacing: HelperMethods().getMyDynamicWidth(10),
                  mainAxisSpacing: HelperMethods().getMyDynamicHeight(0),
                ),
                itemCount: productsList!.length,
                itemBuilder: (BuildContext ctx, index) {
                  return productContainer(
                    productName: productsList![index].productName!,
                    pictureURL:
                        (productsList![index].productImage ?? []).isEmpty
                            ? ''
                            : productsList![index].productImage!.first,
                    gridViewIndex: index,
                  );
                },
              ),
            ),
          );
        }
        if (state is StoreProductsEmptyState) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: HelperMethods().getMyDynamicHeight(36),
                width: HelperMethods().getMyDynamicWidth(36),
                margin: EdgeInsets.only(
                  left: HelperMethods().getMyDynamicWidth(28),
                  top: HelperMethods().getMyDynamicHeight(24),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: const Color(0xFF5F5F5F),
                  ),
                ),
                child: const Image(
                  image: AssetImage('assets/tag_icon.png'),
                  color: Color(0xFF5F5F5F),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: HelperMethods().getMyDynamicWidth(13),
                  top: HelperMethods().getMyDynamicHeight(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Empty Shop?',
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
                      'Fill It With Your Crochet Magic Now!',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: HelperMethods().getMyDynamicFontSize(14),
                        color: const Color(0xFF767676),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }
        if (state is NoInternetState) {
          const snackBar = SnackBar(
            content: Text('No Internet'),
          );
          if (productsList!.isEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: HelperMethods().getMyDynamicHeight(36),
                  width: HelperMethods().getMyDynamicWidth(36),
                  margin: EdgeInsets.only(
                    left: HelperMethods().getMyDynamicWidth(28),
                    top: HelperMethods().getMyDynamicHeight(24),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2,
                      color: const Color(0xFF5F5F5F),
                    ),
                  ),
                  child: Icon(
                    Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
                    color: const Color(0xFF5F5F5F),
                    size: HelperMethods().getMyDynamicHeight(15),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: HelperMethods().getMyDynamicWidth(13),
                    top: HelperMethods().getMyDynamicHeight(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'No Internet',
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
                        'Check Your Internet Connections',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: HelperMethods().getMyDynamicFontSize(14),
                          color: const Color(0xFF767676),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            return Expanded(
              child: RefreshIndicator(
                color: ColorsConfig().kPrimaryColor,
                onRefresh: () async {
                  if (mounted) {
                    await SellerServices().getProductList(context);
                  }
                },
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      left: HelperMethods().getMyDynamicWidth(27),
                      right: HelperMethods().getMyDynamicWidth(28),
                      bottom: HelperMethods().getMyDynamicHeight(80),
                      top: 0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 161 / 200,
                    crossAxisSpacing: HelperMethods().getMyDynamicWidth(10),
                    mainAxisSpacing: HelperMethods().getMyDynamicHeight(0),
                  ),
                  itemCount: productsList!.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return productContainer(
                      productName: productsList![index].productName!,
                      pictureURL:
                          (productsList![index].productImage ?? []).isEmpty
                              ? ''
                              : productsList![index].productImage!.first,
                      gridViewIndex: index,
                    );
                  },
                ),
              ),
            );
          }
        } else {
          return const Center(child: Text('Error loading products'));
        }
      },
    );
  }

  void deleteProduct(int index) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('product');
    QuerySnapshot documentToBeDeleted = await collection
        .where(FieldPath.documentId, isEqualTo: productsList![index].productId)
        .get();
    String idOfDocumentToBeDeleted = documentToBeDeleted.docs.first.id;
    await collection
        .doc(idOfDocumentToBeDeleted)
        .delete()
        .then(
          (value) => {
            productsList!.removeAt(index),
            if (productsList!.isEmpty)
              {
                if (mounted)
                  {
                    context.read<SellerHomePageBloc>().add(
                          StoreProductsEmptyEvent(),
                        )
                  }
              },
            // setState(() {})
          },
        )
        .onError(
          (error, stackTrace) => {},
        );
  }

  Widget productContainer({
    required String productName,
    required String pictureURL,
    required int gridViewIndex,
  }) {
    final GlobalKey iconButtonKey = LabeledGlobalKey("button_icon");
    return BlocBuilder<SellerHomePageBloc, SellerHomePageState>(
      builder: (context, state) {
        if (state is StoreLoading) {
          return Center(
              child: CircularProgressIndicator(
                  color: ColorsConfig().kPrimaryColor));
        }
        if (state is StoreProductsLoaded) {
          productsList = state.products;
          return GestureDetector(
            onTap: () async {
              Get.to(
                () => PreviewProductScreen(
                  imageUrl: productsList![gridViewIndex].productImage!,
                  hookSize: productsList![gridViewIndex].hookSize!,
                  productDetails:
                      productsList![gridViewIndex].productDescription!,
                  productName: productName,
                  productPrice: productsList![gridViewIndex].price!,
                  buttonText: '',
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  height: HelperMethods().getMyDynamicHeight(136),
                  width: HelperMethods().getMyDynamicWidth(161),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        HelperMethods().getMyDynamicHeight(14),
                      ),
                      topRight: Radius.circular(
                        HelperMethods().getMyDynamicHeight(14),
                      ),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        HelperMethods().getMyDynamicHeight(14),
                      ),
                      topRight: Radius.circular(
                        HelperMethods().getMyDynamicHeight(14),
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: pictureURL,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => const Skeleton(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
                Container(
                  height: HelperMethods().getMyDynamicHeight(54),
                  width: HelperMethods().getMyDynamicWidth(161),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        HelperMethods().getMyDynamicHeight(14),
                      ),
                      bottomRight: Radius.circular(
                        HelperMethods().getMyDynamicHeight(14),
                      ),
                    ),
                    color: const Color(0xFFF2F2F2),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: HelperMethods().getMyDynamicWidth(12),
                          top: HelperMethods().getMyDynamicHeight(10),
                        ),
                        width: HelperMethods().getMyDynamicWidth(122),
                        child: Text(
                          productName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: HelperMethods().getMyDynamicFontSize(14),
                          ),
                        ),
                      ),
                      SizedBox(
                        key: iconButtonKey,
                        width: HelperMethods().getMyDynamicWidth(20),
                        child: IconButton(
                          icon: const Icon(Icons.more_vert_sharp),
                          iconSize: HelperMethods().getMyDynamicFontSize(24),
                          padding: EdgeInsets.only(
                            right: HelperMethods().getMyDynamicWidth(10),
                          ),
                          onPressed: () {
                            if (isMenuOpen) {
                              _overlayEntry!.remove();
                              isMenuOpen = !isMenuOpen;
                            } else {
                              RenderBox renderBox = iconButtonKey.currentContext
                                  ?.findRenderObject() as RenderBox;
                              buttonPosition =
                                  renderBox.localToGlobal(Offset.zero);
                              _overlayEntry = OverlayEntry(
                                builder: (context) {
                                  return Positioned(
                                    top: buttonPosition!.dy +
                                        HelperMethods().getMyDynamicHeight(41),
                                    left: (gridViewIndex % 2) != 0
                                        ? (buttonPosition!.dx -
                                            HelperMethods()
                                                .getMyDynamicWidth(90))
                                        : buttonPosition!.dx,
                                    child: Material(
                                      color: Colors.white,
                                      child: Container(
                                        decoration: BoxDecoration(boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF000000)
                                                .withOpacity(0.15),
                                            blurStyle: BlurStyle.normal,
                                            blurRadius: HelperMethods()
                                                .getMyDynamicHeight(12),
                                            offset: Offset(
                                              HelperMethods()
                                                  .getMyDynamicHeight(0),
                                              HelperMethods()
                                                  .getMyDynamicWidth(2),
                                            ),
                                          ),
                                        ], color: Colors.white),
                                        child: Column(
                                          children: List.generate(
                                            dropDownMenuList.length,
                                            (index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  deleteProduct(gridViewIndex);
                                                  _overlayEntry!.remove();
                                                  isMenuOpen = false;
                                                },
                                                child: SizedBox(
                                                  child:
                                                      dropDownMenuList[index],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                              Overlay.of(context).insert(_overlayEntry!);
                              isMenuOpen = !isMenuOpen;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text("Something went wrong while loading user details.");
        }
      },
    );
  }

  Widget latestPostsText() {
    return BlocBuilder<SellerHomePageBloc, SellerHomePageState>(
      builder: (context, state) {
        if (state is StoreProductsLoaded) {
          return Container(
            margin: EdgeInsets.only(
              left: HelperMethods().getMyDynamicWidth(28),
              top: HelperMethods().getMyDynamicHeight(28),
              bottom: HelperMethods().getMyDynamicHeight(24),
            ),
            child: Text(
              'LATEST POSTS',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: HelperMethods().getMyDynamicFontSize(14),
                color: const Color(0xFF24292E),
              ),
            ),
          );
        } else {
          return const Text('');
        }
      },
    );
  }

  Widget floatingActionButton() {
    return Padding(
      padding: EdgeInsets.only(
        right: HelperMethods().getMyDynamicWidth(10),
      ),
      child: FloatingActionButton(
        onPressed: () {
          Get.to(() => const UploadProductPage());
        },
        backgroundColor: ColorsConfig().kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            HelperMethods().getMyDynamicHeight(16),
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Color(0xFFD5D5D5),
        ),
      ),
    );
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(4),
        left: HelperMethods().getMyDynamicWidth(28),
        right: HelperMethods().getMyDynamicWidth(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 0.5,
              color: const Color(0xFF1A444D).withOpacity(0.3),
            ),
            /* Divider(
              thickness: 0.5,
              color: const Color(0xFF1A444D).withOpacity(0.3),
            ), */
          ),
        ],
      ),
    );
  }

  Widget profilePictureCircle() {
    StoreModel shopDetails;
    return BlocBuilder<StoreDetailsBlocBloc, StoreDetailsBlocState>(
      builder: (context, state) {
        if (state is StoreDetailsLoaded) {
          shopDetails = state.storeDetails!;
          return Row(
            children: [
              Container(
                height: HelperMethods().getMyDynamicHeight(100),
                width: HelperMethods().getMyDynamicWidth(100),
                margin: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(44),
                  left: HelperMethods().getMyDynamicWidth(29),
                ),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      HelperMethods().getMyDynamicHeight(50),
                    ),
                  ),
                  child: shopDetails.imageUrl == null
                      ? Image.asset(
                          'assets/profile_avatar.png',
                          fit: BoxFit.contain,
                        )
                      : Image.network(
                          shopDetails.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Container(
                height: HelperMethods().getMyDynamicHeight(100),
                width: HelperMethods().getMyDynamicWidth(100),
                margin: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(44),
                  left: HelperMethods().getMyDynamicWidth(29),
                ),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      HelperMethods().getMyDynamicHeight(50),
                    ),
                  ),
                  child: Image.asset(
                    'assets/profile_avatar.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget storeDescription() {
    return BlocBuilder<StoreDetailsBlocBloc, StoreDetailsBlocState>(
        builder: (context, state) {
      if (state is StoreDetailsLoading) {}
      if (state is StoreDetailsLoaded) {
        storeDetails = state.storeDetails;
        return Container(
          margin: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(29),
            right: HelperMethods().getMyDynamicWidth(27),
            top: HelperMethods().getMyDynamicHeight(20),
          ),
          child: Text(
            (storeDetails!.shopDescription ?? '').isEmpty
                ? ''
                : storeDetails!.shopDescription ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: HelperMethods().getMyDynamicFontSize(16),
              color: ColorsConfig().descriptionTextColor,
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Widget storeCity() {
    return BlocBuilder<StoreDetailsBlocBloc, StoreDetailsBlocState>(
        builder: (context, state) {
      if (state is StoreDetailsLoading) {}
      if (state is StoreDetailsLoaded) {
        storeDetails = state.storeDetails;
        return Container(
          height: HelperMethods().getMyDynamicHeight(24),
          margin: EdgeInsets.only(
              left: HelperMethods().getMyDynamicWidth(25),
              bottom: HelperMethods().getMyDynamicHeight(3)),
          padding: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(11),
            right: HelperMethods().getMyDynamicWidth(10),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              HelperMethods().getMyDynamicHeight(5),
            ),
            color: const Color(0xFFD5D5D5),
          ),
          child: Center(
            child: Text(
              (storeDetails!.city ?? '').isEmpty
                  ? ''
                  : storeDetails!.city ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: HelperMethods().getMyDynamicFontSize(12),
                color: const Color(0xFF767676),
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Widget storeName() {
    return BlocBuilder<StoreDetailsBlocBloc, StoreDetailsBlocState>(
      builder: (context, state) {
        if (state is StoreDetailsLoading) {}
        if (state is StoreDetailsLoaded) {
          storeDetails = state.storeDetails;
          UserServices().saveFCMTokenIntoDb(storeDetails!.storeId!);
          return Container(
            margin: EdgeInsets.only(
              left: HelperMethods().getMyDynamicWidth(29),
            ),
            child: Text(
              (storeDetails!.shopName ?? '').isEmpty
                  ? ''
                  : storeDetails!.shopName ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: HelperMethods().getMyDynamicFontSize(24),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
