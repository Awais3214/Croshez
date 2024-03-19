import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/bloc/user_details_bloc/user_bloc_bloc.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/src/pages/authentication/age_verification.dart';
import 'package:croshez/src/pages/authentication/welcome_landing.dart';
import 'package:croshez/src/pages/buyer/buyer_orders.dart';
import 'package:croshez/src/pages/buyer/manage_addresses_page.dart';
import 'package:croshez/src/pages/buyer/profile_settings_page.dart';
import 'package:croshez/src/pages/seller/store_page_bottom_navbar.dart';
import 'package:croshez/utils/my_shared_preferecnces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../helper/common_methods.dart';
import '../../../models/user_model.dart';
import '../../../utils/constants.dart';

class BuyerProfilePage extends StatefulWidget {
  const BuyerProfilePage({super.key});

  @override
  State<BuyerProfilePage> createState() => _BuyerProfilePageState();
}

class _BuyerProfilePageState extends State<BuyerProfilePage> {
  bool isSwitched = false;
  bool isLoading = false;
  bool isTapped = false;

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
              userName(),
            ],
          ),
          pageDescriptionText(),
          divider(28, const Color(0xFFD5D5D5)),
          profilePageOptions(
            'Edit Your Profile',
            'View and edit your profile',
            Icons.account_circle_outlined,
            92,
            onTap: () {
              Get.to(
                () => const ProfileSettingsPage(),
              );
            },
          ),
          profilePageOptions(
            'Your Saved Addresses',
            'Manage your addresses here',
            Icons.location_on,
            66,
            onTap: () {
              Get.to(
                () => const ManageAddressesPage(),
              );
            },
          ),
          profilePageOptions(
            'Your Orders',
            'Manage your orders here',
            Icons.filter_frames_outlined,
            97,
            onTap: () {
              Get.to(
                () => const BuyerOrdersPage(),
              );
            },
          ),
          becomeASellerOption(),
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
                                Get.offAll(() => const WelcomeLanding());
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

  Future<bool> checkIfAlreadySeller() async {
    isLoading = true;
    CollectionReference storeCollection =
        FirebaseFirestore.instance.collection("shop");
    User user = FirebaseAuth.instance.currentUser!;
    QuerySnapshot storeDocumentIfIdExists =
        await storeCollection.where('userId', isEqualTo: user.uid).get();
    isLoading = false;
    if (storeDocumentIfIdExists.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Widget becomeASellerOption() {
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
                      'Become A Seller',
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
                      'Sell on the marketplace',
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
                behavior: HitTestBehavior.translucent,
                onTap: isTapped
                    ? null
                    : () async {
                        isTapped = true;
                        isSwitched = !isSwitched;
                        setState(() {});
                        bool isConnected = await Conn().connectivityResult();
                        if (isConnected) {
                          bool isSeller = await checkIfAlreadySeller();
                          if (isSeller) {
                            await Get.offAll(
                                () => const StorePageBottomNavBar());
                          } else {
                            Get.to(
                              () => const VerifyAgePage(),
                            );
                          }
                        } else {
                          const snackBar =
                              SnackBar(content: Text('No Internet'));
                          if (mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                        isTapped = false;
                        isSwitched = !isSwitched;
                        setState(() {});
                      },
                onHorizontalDragStart: (details) async {
                  isTapped = true;
                  bool isConnected = await Conn().connectivityResult();
                  if (isConnected) {
                    isSwitched = !isSwitched;
                    setState(() {});
                    bool isSeller = await checkIfAlreadySeller();
                    if (isSeller) {
                      Get.offAll(() => const StorePageBottomNavBar());
                    } else {
                      Get.to(
                        () => const VerifyAgePage(),
                      );
                    }
                    isSwitched = !isSwitched;
                    setState(() {});
                  } else {
                    const snackBar = SnackBar(content: Text('No Internet'));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                  isTapped = false;
                  isSwitched = !isSwitched;
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: isSwitched
                        ? HelperMethods().getMyDynamicWidth(76)
                        : HelperMethods().getMyDynamicWidth(70),
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

  Widget profilePageOptions(
    String header,
    String description,
    IconData icon,
    double lastIconLeftMargin, {
    Function? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
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
        'Manage Your Profile Here',
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: HelperMethods().getMyDynamicFontSize(16),
            color: ColorsConfig().descriptionTextColor),
      ),
    );
  }

  Widget userName() {
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
          UserModel? gUserDetails = state.userDetails;
          return Container(
            margin: EdgeInsets.only(
              left: HelperMethods().getMyDynamicWidth(16),
              top: HelperMethods().getMyDynamicHeight(76),
            ),
            child: Text(
              gUserDetails!.fullname ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: HelperMethods().getMyDynamicFontSize(22),
              ),
            ),
          );
        }
        if (state is EmptyUserDetails) {
          return Container(
            margin: EdgeInsets.only(
              left: HelperMethods().getMyDynamicWidth(16),
              top: HelperMethods().getMyDynamicHeight(76),
            ),
            child: Text(
              'Your Name',
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
              'Error loading user information',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: HelperMethods().getMyDynamicFontSize(22),
              ),
            ),
          );
        }
      },
    );
  }

  Widget profilePictureCircle() {
    UserBlocState state = context.read<UserBlocBloc>().state;
    UserModel user;
    if (state is LoadedUserDetails) {
      user = state.userDetails!;
      if (user.profilePicture != null && user.profilePicture != '') {
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
            child: Image.network(
              user.profilePicture!,
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
  }
}
