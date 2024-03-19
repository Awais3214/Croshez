import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/models/store_model.dart';
import 'package:croshez/src/pages/buyer/buyer_home_bottom_navbar.dart';
import 'package:croshez/src/pages/seller/shop_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../bloc/seller_home_page_bloc/seller_home_page_bloc.dart';
import '../../../bloc/store_details_bloc/store_details_bloc_bloc.dart';
import '../../../helper/common_methods.dart';
import '../../../models/user_model.dart';
import '../../../root_page.dart';
import '../../../utils/constants.dart';
import '../../../utils/my_shared_preferecnces.dart';

class SellerProfilePage extends StatefulWidget {
  const SellerProfilePage({super.key});

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  bool isSwitched = false;
  bool isLoading = false;
  List<dynamic> role = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              profilePictureCircle(),
              storeName(),
              storeCity(),
            ],
          ),
          pageDescriptionText(),
          divider(28, const Color(0xFFD5D5D5)),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Get.to(
                () => const ShopProfilePage(),
              );
            },
            child: profilePageOptions(
                'Edit Your Profile',
                'View and edit your profile',
                Icons.account_circle_outlined,
                92),
          ),
          becomeABuyerOption(),
          SizedBox(
            height: HelperMethods().getMyDynamicHeight(96),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Log Out?'),
                          content: const Text(
                              'Are you sure you want to logout of your Croshez session?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                bool isConnected =
                                    await Conn().connectivityResult();
                                if (isConnected) {
                                  await MySharedPreferecne().clearAllData();
                                  await FirebaseAuth.instance.signOut();
                                } else {
                                  if (mounted) {
                                    var snackBar = const SnackBar(
                                        content: Text('No Internet'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                                if (mounted) {
                                  Navigator.of(context).pop();
                                }
                                Get.offAll(() => const RootPage());
                              },
                              child: const Text('Yes'),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Log out',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkIfAlreadyBuyer() async {
    isLoading = true;
    CollectionReference storeCollection =
        FirebaseFirestore.instance.collection("users");
    User user = FirebaseAuth.instance.currentUser!;
    QuerySnapshot userDocument = await storeCollection
        .where(FieldPath.documentId, isEqualTo: user.uid)
        .get();
    List<UserModel> userData = userDocument.docs
        .map((e) => UserModel.fromMap(
              e.data(),
            ))
        .toList();
    role = userData[0].role!;

    isLoading = false;
    if (!role.contains('Buyer')) {
      return false;
    } else {
      return true;
    }
  }

  Widget becomeABuyerOption() {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: HelperMethods().getMyDynamicWidth(28),
                  top: HelperMethods().getMyDynamicHeight(8),
                ),
                child: Icon(
                  Icons.store_mall_directory_outlined,
                  color: ColorsConfig().kPrimaryColor,
                  size: HelperMethods().getMyDynamicHeight(24),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: HelperMethods().getMyDynamicWidth(16),
                    ),
                    child: Text(
                      'Switch to Shopping',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: HelperMethods().getMyDynamicFontSize(18),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: HelperMethods().getMyDynamicHeight(8),
                      left: HelperMethods().getMyDynamicWidth(16),
                    ),
                    child: Text(
                      'Explore the marketplace',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: HelperMethods().getMyDynamicFontSize(16),
                        color: ColorsConfig().descriptionTextColor,
                      ),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () async {
                  isSwitched = !isSwitched;
                  setState(() {});

                  bool isConnected = await Conn().connectivityResult();
                  if (isConnected) {
                    bool isBuyer = await checkIfAlreadyBuyer();
                    if (isBuyer) {
                      Get.offAll(() => const BuyerPageBottomNavBar());
                    }
                    User user = FirebaseAuth.instance.currentUser!;
                    if (!role.contains('Buyer')) {
                      role.add('Buyer');
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.uid)
                          .update({"role": role})
                          .then((document) {})
                          .catchError((_) {});
                      Get.offAll(() => const BuyerPageBottomNavBar());
                    }
                  } else {
                    isSwitched = !isSwitched;
                    const snackBar = SnackBar(content: Text('No Internet'));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                onHorizontalDragStart: (details) async {
                  isSwitched = !isSwitched;
                  setState(() {});

                  bool isConnected = await Conn().connectivityResult();
                  if (isConnected) {
                    bool isBuyer = await checkIfAlreadyBuyer();
                    if (isBuyer) {
                      Get.offAll(() => const BuyerPageBottomNavBar());
                    }
                    User user = FirebaseAuth.instance.currentUser!;
                    if (!role.contains('Buyer')) {
                      role.add('Buyer');
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.uid)
                          .update({"role": role})
                          .then((document) {})
                          .catchError((_) {});
                      Get.offAll(() => const BuyerPageBottomNavBar());
                    }
                  } else {
                    isSwitched = !isSwitched;
                    const snackBar = SnackBar(content: Text('No Internet'));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: isSwitched
                        ? HelperMethods().getMyDynamicWidth(66)
                        : HelperMethods().getMyDynamicWidth(60),
                    right: isSwitched
                        ? HelperMethods().getMyDynamicWidth(14)
                        : HelperMethods().getMyDynamicWidth(20),
                  ),
                  child: Image.asset(
                    isSwitched
                        ? 'assets/active_switch.png'
                        : 'assets/unactive_switch.png',
                    width: HelperMethods().getMyDynamicWidth(52),
                    height: HelperMethods().getMyDynamicHeight(32),
                  ),
                ),
              ),
            ],
          ),
          divider(24, const Color(0xFF989898)),
        ],
      ),
    );
  }

  Widget profilePageOptions(String header, String description, IconData icon,
      double lastIconLeftMargin) {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: HelperMethods().getMyDynamicWidth(28),
                  top: HelperMethods().getMyDynamicHeight(8),
                ),
                child: Icon(
                  icon,
                  color: ColorsConfig().kPrimaryColor,
                  size: HelperMethods().getMyDynamicHeight(24),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: HelperMethods().getMyDynamicWidth(16),
                    ),
                    child: Text(
                      header,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: HelperMethods().getMyDynamicFontSize(18),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: HelperMethods().getMyDynamicHeight(8),
                      left: HelperMethods().getMyDynamicWidth(16),
                    ),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: HelperMethods().getMyDynamicFontSize(16),
                        color: ColorsConfig().descriptionTextColor,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  left: HelperMethods().getMyDynamicWidth(lastIconLeftMargin),
                ),
                height: HelperMethods().getMyDynamicHeight(11.08),
                width: HelperMethods().getMyDynamicWidth(6.42),
                child: Icon(
                  Icons.arrow_back_ios,
                  textDirection: TextDirection.rtl,
                  color: ColorsConfig().descriptionTextColor,
                  size: HelperMethods().getMyDynamicHeight(11.08),
                ),
              )
            ],
          ),
          divider(24, const Color(0xFF989898)),
        ],
      ),
    );
  }

  Widget divider(double topMargin, Color color) {
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
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget pageDescriptionText() {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(14),
        left: HelperMethods().getMyDynamicWidth(91),
      ),
      child: Text(
        'Manage Your Shop Profile Here',
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: HelperMethods().getMyDynamicFontSize(16),
            color: ColorsConfig().descriptionTextColor),
      ),
    );
  }

  Widget storeCity() {
    return BlocBuilder<StoreDetailsBlocBloc, StoreDetailsBlocState>(
        builder: (context, state) {
      if (state is StoreLoading) {
        return Center(
          child: CircularProgressIndicator(color: ColorsConfig().kPrimaryColor),
        );
      }
      if (state is StoreDetailsLoaded) {
        StoreModel? storeDetails = state.storeDetails;
        return Container(
          height: HelperMethods().getMyDynamicHeight(24),
          margin: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(24),
            top: HelperMethods().getMyDynamicHeight(77),
          ),
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
              (storeDetails!.city ?? '').isNotEmpty
                  ? storeDetails.city ?? ''
                  : "",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: HelperMethods().getMyDynamicFontSize(12),
                color: const Color(0xFF767676),
              ),
            ),
          ),
        );
      } else {
        return const Text("");
      }
    });
  }

  Widget storeName() {
    return BlocBuilder<StoreDetailsBlocBloc, StoreDetailsBlocState>(
        builder: (context, state) {
      if (state is StoreLoading) {
        return Center(
            child:
                CircularProgressIndicator(color: ColorsConfig().kPrimaryColor));
      }
      if (state is StoreDetailsLoaded) {
        StoreModel? storeDetails = state.storeDetails;
        return Container(
          margin: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(16),
            top: HelperMethods().getMyDynamicHeight(76),
          ),
          child: Text(
            (storeDetails!.shopName ?? '').isEmpty
                ? ''
                : storeDetails.shopName ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: HelperMethods().getMyDynamicFontSize(22),
            ),
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(16),
            top: HelperMethods().getMyDynamicHeight(76),
          ),
          width: HelperMethods().getMyDynamicWidth(250),
          child: Text(
            'Error loading shop details',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: HelperMethods().getMyDynamicFontSize(22),
            ),
          ),
        );
      }
    });
  }

  Widget profilePictureCircle() {
    return BlocBuilder<StoreDetailsBlocBloc, StoreDetailsBlocState>(
      builder: (context, state) {
        if (state is StoreDetailsLoaded) {
          StoreModel store = state.storeDetails!;
          return Container(
            height: HelperMethods().getMyDynamicHeight(47),
            width: HelperMethods().getMyDynamicWidth(47),
            margin: EdgeInsets.only(
              top: HelperMethods().getMyDynamicHeight(65),
              left: HelperMethods().getMyDynamicWidth(28),
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
              child: store.imageUrl == null
                  ? Image.asset(
                      'assets/profile_avatar_without_camera.png',
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      store.imageUrl!,
                      fit: BoxFit.cover,
                    ),
            ),
          );
        } else {
          return Container(
            height: HelperMethods().getMyDynamicHeight(47),
            width: HelperMethods().getMyDynamicWidth(47),
            margin: EdgeInsets.only(
              top: HelperMethods().getMyDynamicHeight(65),
              left: HelperMethods().getMyDynamicWidth(28),
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
                'assets/profile_avatar_without_camera.png',
                fit: BoxFit.contain,
              ),
            ),
          );
        }
      },
    );
  }
}
