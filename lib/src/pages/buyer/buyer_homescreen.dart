import 'package:cached_network_image/cached_network_image.dart';
import 'package:croshez/bloc/user_details_bloc/user_bloc_bloc.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/models/product_model.dart';
import 'package:croshez/models/user_model.dart';
import 'package:croshez/src/pages/buyer/product_details.dart';
import 'package:croshez/utils/constants.dart';
import 'package:croshez/utils/my_shared_preferecnces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import '../../../bloc/buyer_home_page_bloc/products_bloc.dart';
import '../../../helper/common_methods.dart';
import '../../../utils/buyer_services.dart';
import '../../widgets/skeleton_loading.dart';
import '../../widgets/filter_overlay_menu.dart';

class BuyerHome extends StatefulWidget {
  const BuyerHome({super.key});

  @override
  State<BuyerHome> createState() => _HomeState();
}

class _HomeState extends State<BuyerHome> {
  List<ProductModel> products = [];
  List<ProductModel> searchedProducts = [];
  List<String> selectedFilters = [];
  FocusNode searchBarFocusNode = FocusNode();
  TextEditingController searchBarController = TextEditingController();

  @override
  void initState() {
    MySharedPreferecne().saveUserType('Buyer');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        searchBarFocusNode.unfocus();
      },
      child: Scaffold(
        body:
            BlocBuilder<ProductsBloc, ProductsState>(builder: (context, state) {
          if (state is ProductsLoading) {
            return Center(
              child: CircularProgressIndicator(
                  color: ColorsConfig().kPrimaryColor),
            );
          }
          if (state is ProductsLoaded) {
            products = state.products;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: HelperMethods().getMyDynamicHeight(32),
                  ),
                  child: greetingDescription(),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      bool isConnected = await Conn().connectivityResult();
                      if (isConnected) {
                        if (mounted) {
                          await BuyerServices().getAllProducts(context);
                        }
                      }
                    },
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: HelperMethods().getMyDynamicHeight(10),
                            bottom: HelperMethods().getMyDynamicHeight(10)),
                        child: Column(
                          children: [
                            searchBar(products),
                            filtersMenuButton(),
                            Container(
                              margin: EdgeInsets.only(
                                left: HelperMethods().getMyDynamicWidth(28),
                                right: HelperMethods().getMyDynamicWidth(28),
                              ),
                              child: productTiles(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          if (state is ProductsEmptyState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: HelperMethods().getMyDynamicHeight(32),
                  ),
                  child: greetingDescription(),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      bool isConnected = await Conn().connectivityResult();
                      if (isConnected) {
                        if (mounted) {
                          await BuyerServices().getAllProducts(context);
                        }
                        if (mounted) {
                          if (context.read<UserBlocBloc>().state ==
                              EmptyUserDetails()) {
                            await BuyerServices().getUserDetails(context);
                          }
                        }
                      }
                    },
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: HelperMethods().getMyDynamicHeight(10),
                              bottom: HelperMethods().getMyDynamicHeight(10)),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: HelperMethods().getMyDynamicWidth(28),
                                  right: HelperMethods().getMyDynamicWidth(28),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: HelperMethods()
                                          .getMyDynamicHeight(36),
                                      width:
                                          HelperMethods().getMyDynamicWidth(36),
                                      margin: EdgeInsets.only(
                                        left: HelperMethods()
                                            .getMyDynamicWidth(6),
                                        top: HelperMethods()
                                            .getMyDynamicHeight(32),
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
                                              'assets/empty_product_icon.png'),
                                          color: Color(0xFF5F5F5F),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: HelperMethods()
                                            .getMyDynamicWidth(13),
                                        top: HelperMethods()
                                            .getMyDynamicHeight(28),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'The Store Is Empty',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: HelperMethods()
                                                  .getMyDynamicFontSize(16),
                                              color: const Color(0xFF24292E),
                                            ),
                                          ),
                                          SizedBox(
                                            height: HelperMethods()
                                                .getMyDynamicHeight(6),
                                          ),
                                          Text(
                                            'Our Crochet Workers Are Doing Their Best!',
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          if (state is NoInternetState) {
            const snackBar = SnackBar(content: Text('No Internet'));
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
                    left: HelperMethods().getMyDynamicWidth(6),
                    top: HelperMethods().getMyDynamicHeight(32),
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
                    child: Icon(
                      Icons.signal_wifi_connected_no_internet_4,
                      size: HelperMethods().getMyDynamicHeight(15),
                      color: const Color(0xFF5F5F5F),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: HelperMethods().getMyDynamicWidth(13),
                    top: HelperMethods().getMyDynamicHeight(28),
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
                        'Check Your Internet Connection',
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
            return const Text(
                "Something went wrong while loading products for the buyer home. Please restart the app.");
          }
        }),
      ),
    );
  }

  Widget filtersMenuButton() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return FilterOverlayPage(
              selectedHookSizes: selectedFilters,
            );
          },
          backgroundColor: Colors.blueGrey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                HelperMethods().getMyDynamicHeight(50),
              ),
              topRight: Radius.circular(
                HelperMethods().getMyDynamicHeight(50),
              ),
            ),
          ),
        ).then((value) {
          if (value == null) {
          } else {
            selectedFilters = value;
            setState(() {});
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(
          top: HelperMethods().getMyDynamicHeight(20),
        ),
        height: HelperMethods().getMyDynamicHeight(40),
        width: HelperMethods().getMyDynamicWidth(180),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(
            HelperMethods().getMyDynamicHeight(30),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: HelperMethods().getMyDynamicWidth(20),
              ),
              child: Icon(
                Icons.filter_alt_outlined,
                color: ColorsConfig().kPrimaryColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: HelperMethods().getMyDynamicWidth(10),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xff49454F),
                    letterSpacing: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBar(List<ProductModel> allProducts) {
    return Container(
      width: HelperMethods().getMyDynamicWidth(334),
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(24),
        left: HelperMethods().getMyDynamicWidth(28),
        right: HelperMethods().getMyDynamicWidth(28),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: HelperMethods().getMyDynamicHeight(20),
          ),
        ],
      ),
      child: OutlineSearchBar(
        focusNode: searchBarFocusNode,
        textEditingController: searchBarController,
        onSearchButtonPressed: (value) {
          searchedProducts.clear();
          for (int i = 0; i < products.length; i++) {
            if (products[i].productName!.toLowerCase().contains(value)) {
              searchedProducts.add(products[i]);
            }
          }
          setState(() {});
          if (searchedProducts.isEmpty) {
            const snackBar = SnackBar(
              content: Text('No Products Matched Your Search Query'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        onKeywordChanged: (value) {
          searchedProducts.clear();
          for (int i = 0; i < products.length; i++) {
            if (products[i].productName!.toLowerCase().contains(value)) {
              searchedProducts.add(products[i]);
            }
          }
          setState(() {});
        },
        borderWidth: 1,
        borderColor: Colors.white,
        searchButtonPosition: SearchButtonPosition.leading,
        searchButtonIconColor: const Color(0xFF49454F),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        hintText: "What are you looking for?",
        hintStyle: GoogleFonts.inter(
          fontSize: HelperMethods().getMyDynamicFontSize(16),
          fontWeight: FontWeight.w400,
          color: const Color(0xff49454F),
          letterSpacing: 0.75,
        ),
        textPadding: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(24),
        ),
      ),
    );
  }

  Widget greetingDescription() {
    return BlocBuilder<UserBlocBloc, UserBlocState>(
      builder: (context, state) {
        if (state is LoadingUserDetails) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorsConfig().kPrimaryColor,
            ),
          );
        }
        if (state is LoadedUserDetails) {
          List<String> firstName = [];
          UserModel? gUserDetails = state.userDetails;
          firstName = gUserDetails!.fullname!.split(' ');
          return Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: HelperMethods().getMyDynamicHeight(30),
                    left: HelperMethods().getMyDynamicWidth(28),
                  ),
                  child: Text(
                    gUserDetails.fullname == null
                        ? "Hi"
                        : "Hi ${firstName[0]},",
                    style: GoogleFonts.inter(
                        fontSize: HelperMethods().getMyDynamicFontSize(24),
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: HelperMethods().getMyDynamicHeight(20),
                    left: HelperMethods().getMyDynamicWidth(28),
                  ),
                  child: Text(
                    "Explore top picks curated just for you.",
                    style: GoogleFonts.inter(
                      fontSize: HelperMethods().getMyDynamicFontSize(16),
                      fontWeight: FontWeight.w400,
                      color: ColorsConfig().kPrimaryLightColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
          );
        }
        if (state is EmptyUserDetails) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: HelperMethods().getMyDynamicHeight(30),
                    left: HelperMethods().getMyDynamicWidth(28),
                  ),
                  child: Text(
                    "Hi",
                    style: GoogleFonts.inter(
                        fontSize: HelperMethods().getMyDynamicFontSize(24),
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: HelperMethods().getMyDynamicHeight(20),
                    left: HelperMethods().getMyDynamicWidth(28),
                  ),
                  child: Text(
                    "Explore top picks curated just for you.",
                    style: GoogleFonts.inter(
                      fontSize: HelperMethods().getMyDynamicFontSize(16),
                      fontWeight: FontWeight.w400,
                      color: ColorsConfig().kPrimaryLightColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
          );
        } else {
          return const Text("Something went wrong while loading user details.");
        }
      },
    );
  }

  List<ProductModel> getfilteredProducts(List<ProductModel> allProd) {
    List<ProductModel> filteredPro = [];
    for (int i = 0; i < allProd.length; i++) {
      if (selectedFilters.contains(allProd[i].hookSize)) {
        filteredPro.add(allProd[i]);
      }
    }

    return filteredPro;
  }

  Widget productTiles() {
    List<ProductModel> newProductsList = [];
    if (searchBarController.text.isEmpty) {
      newProductsList = products;
    } else {
      newProductsList = searchedProducts;
    }
    if (selectedFilters.isNotEmpty) {
      newProductsList = getfilteredProducts(newProductsList);
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: HelperMethods().getMyDynamicWidth(10),
        mainAxisSpacing: HelperMethods().getMyDynamicHeight(10),
        childAspectRatio: 160 / 200,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: newProductsList.length,
      itemBuilder: (context, index) {
        ProductModel product = newProductsList[index];
        String productTitle = product.productName!;
        String price = product.price!;
        String imgPath = '';
        if ((product.productImage ?? []).isNotEmpty) {
          imgPath = product.productImage!.first;
        }
        return GestureDetector(
          onTap: () {
            Get.to(
              () => ProductDetails(
                product,
              ),
            );
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(14),
                          topLeft: Radius.circular(14),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: imgPath,
                          width: HelperMethods().getMyDynamicWidth(160),
                          height: HelperMethods().getMyDynamicHeight(146),
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  const Skeleton(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: HelperMethods().getMyDynamicWidth(160),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: HelperMethods().getMyDynamicHeight(10),
                            bottom: HelperMethods().getMyDynamicHeight(10),
                            left: HelperMethods().getMyDynamicWidth(12),
                            right: HelperMethods().getMyDynamicWidth(12),
                          ),
                          child: Text(
                            productTitle,
                            style: GoogleFonts.inter(
                              fontSize:
                                  HelperMethods().getMyDynamicFontSize(10),
                              fontWeight: FontWeight.w500,
                              color: ColorsConfig().kPrimaryColor,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: HelperMethods().getMyDynamicWidth(160),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: HelperMethods().getMyDynamicWidth(12),
                            right: HelperMethods().getMyDynamicWidth(12),
                          ),
                          child: Text(
                            "Rs. $price",
                            style: GoogleFonts.inter(
                              fontSize:
                                  HelperMethods().getMyDynamicFontSize(16),
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
