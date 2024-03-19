import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/src/pages/buyer/buyer_home_bottom_navbar.dart';
import 'package:croshez/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../helper/common_methods.dart';
import '../../../utils/auth_service.dart';
import 'age_verification.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  String role = '';
  String header = 'Welcome to Croshez!';
  String description =
      'Begin your crochet journey by selecting a role that suits you best. Remember, you can always switch or explore both roles later on.';
  String roleButtonHeader1 = 'Create My Store';
  String roleButtonDescription1 =
      'Showcase your creations and grow your crochet business.';
  String roleButtonHeader2 = 'Shop Crochet Items';
  String roleButtonDescription2 =
      'Discover unique items and support talented artisans.';
  bool _isLoading = false;
  bool isB1Tapped = false;
  bool isB2Tapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            divider(),
            pageHeaderText(),
            descriptionText(),
            roleSelectButton1(),
            roleSelectButton2(),
            continueButton(),
          ],
        ),
      ),
    );
  }

  // defineUserType() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final documentId = prefs.getString('documentId');
  //   if (role == 'Buyer') {
  //     FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(documentId)
  //         .update({"userType": "IqaeG0rTfufW4NDuRfYf"}).then((document) {
  //       prefs.setString('UserType', "IqaeG0rTfufW4NDuRfYf");
  //     }).catchError((_) {
  //       print("an error occured");
  //     });
  //   } else if (role == 'Seller') {
  //     FirebaseFirestore.instance
  //         .collection("users")
  //         .add({"userType": "CHcuSp659hGXL2JG3FdN"}).then((document) {
  //       prefs.setString('UserType', "CHcuSp659hGXL2JG3FdN");
  //     }).catchError((_) {
  //       print("an error occured");
  //     });
  //   }
  // }

  Widget continueButton() {
    return GestureDetector(
      onTap: _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              bool isConnected = await Conn().connectivityResult();
              if (isConnected) {
                User? user = FirebaseAuth.instance.currentUser;
                await AuthService().setRole(user, role);
                role == ''
                    ? null
                    : role == "Seller"
                        ? Get.to(
                            () => const VerifyAgePage(),
                          )
                        : Get.off(() => const BuyerPageBottomNavBar());
                setState(() {
                  _isLoading = false;
                });
              } else {
                const snackBar = SnackBar(content: Text('No Internet'));
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            },
      child: Container(
        height: HelperMethods().getMyDynamicHeight(48),
        width: HelperMethods().getMyDynamicWidth(330),
        margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(80),
            left: HelperMethods().getMyDynamicWidth(30)),
        decoration: BoxDecoration(
          color: role == ''
              ? ColorsConfig().kPrimaryLightColor
              : ColorsConfig().kPrimaryColor,
          borderRadius: BorderRadius.circular(
            HelperMethods().getMyDynamicHeight(8),
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Center(
                child: Text(
                  'Continue',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: HelperMethods().getMyDynamicFontSize(16),
                      fontWeight: FontWeight.w500),
                ),
              ),
      ),
    );
  }

  Widget roleSelectButton2() {
    return GestureDetector(
      onTap: isB2Tapped
          ? null
          : () {
              isB2Tapped = true;
              isB1Tapped = false;
              setState(() {
                role = 'Buyer';
              });
            },
      child: Container(
        width: HelperMethods().getMyDynamicWidth(334.8),
        margin: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(30),
            top: HelperMethods().getMyDynamicHeight(32)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            HelperMethods().getMyDynamicHeight(8),
          ),
          border: Border.all(
            color: role == 'Buyer'
                ? ColorsConfig().selectedRoleBoxBorderColor
                : ColorsConfig().borderColor,
            width: HelperMethods().getMyDynamicWidth(2),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: HelperMethods().getMyDynamicHeight(81),
              width: HelperMethods().getMyDynamicWidth(87),
              margin: EdgeInsets.only(
                  left: HelperMethods().getMyDynamicWidth(16),
                  top: HelperMethods().getMyDynamicHeight(16),
                  bottom: HelperMethods().getMyDynamicHeight(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  HelperMethods().getMyDynamicHeight(6),
                ),
              ),
              child: Image.asset('assets/crochet_seller_icon.png'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: HelperMethods().getMyDynamicWidth(152),
                    height: HelperMethods().getMyDynamicHeight(20),
                    margin: EdgeInsets.only(
                        left: HelperMethods().getMyDynamicWidth(24),
                        top: HelperMethods().getMyDynamicHeight(24)),
                    child: Text(
                      roleButtonHeader2,
                      style: TextStyle(
                        fontSize: HelperMethods().getMyDynamicFontSize(16),
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                Container(
                  width: HelperMethods().getMyDynamicWidth(187),
                  height: HelperMethods().getMyDynamicHeight(36),
                  margin: EdgeInsets.only(
                      left: HelperMethods().getMyDynamicWidth(24),
                      right: HelperMethods().getMyDynamicWidth(13),
                      top: HelperMethods().getMyDynamicHeight(5),
                      bottom: HelperMethods().getMyDynamicHeight(28)),
                  child: Text(
                    roleButtonDescription2,
                    style: TextStyle(
                        fontSize: HelperMethods().getMyDynamicFontSize(12),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff767676)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget roleSelectButton1() {
    return GestureDetector(
      onTap: isB1Tapped
          ? null
          : () {
              isB2Tapped = false;
              isB1Tapped = true;
              // SchedulerBinding.instance.addPostFrameCallback((_) async {
              setState(() {
                role = 'Seller';
              });
              // if (role != "") {
              //   User? user = FirebaseAuth.instance.currentUser;
              //   await AuthService().setRole(user, role);
              // }
              // });
            },
      child: Container(
        width: HelperMethods().getMyDynamicWidth(334.8),
        margin: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(30),
            top: HelperMethods().getMyDynamicHeight(32)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            HelperMethods().getMyDynamicHeight(8),
          ),
          border: Border.all(
            color: role == 'Seller'
                ? ColorsConfig().selectedRoleBoxBorderColor
                : ColorsConfig().borderColor,
            width: HelperMethods().getMyDynamicWidth(2),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: HelperMethods().getMyDynamicHeight(81),
              width: HelperMethods().getMyDynamicWidth(87),
              margin: EdgeInsets.only(
                left: HelperMethods().getMyDynamicWidth(16),
                top: HelperMethods().getMyDynamicHeight(16),
                bottom: HelperMethods().getMyDynamicHeight(16),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  HelperMethods().getMyDynamicHeight(6),
                ),
              ),
              child: SvgPicture.asset('assets/crochet_shop_icon.svg'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: HelperMethods().getMyDynamicWidth(125),
                    height: HelperMethods().getMyDynamicHeight(20),
                    margin: EdgeInsets.only(
                      left: HelperMethods().getMyDynamicWidth(24),
                      top: HelperMethods().getMyDynamicHeight(24),
                    ),
                    child: Text(
                      roleButtonHeader1,
                      style: TextStyle(
                        fontSize: HelperMethods().getMyDynamicFontSize(16),
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                Container(
                  width: HelperMethods().getMyDynamicWidth(187),
                  height: HelperMethods().getMyDynamicHeight(36),
                  margin: EdgeInsets.only(
                      left: HelperMethods().getMyDynamicWidth(24),
                      right: HelperMethods().getMyDynamicWidth(16),
                      top: HelperMethods().getMyDynamicHeight(6),
                      bottom: HelperMethods().getMyDynamicHeight(27)),
                  child: Text(
                    roleButtonDescription1,
                    style: TextStyle(
                      fontSize: HelperMethods().getMyDynamicFontSize(12),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff767676),
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

  Widget descriptionText() {
    return Container(
      margin: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(31),
          right: HelperMethods().getMyDynamicWidth(52),
          top: HelperMethods().getMyDynamicHeight(36)),
      child: Text(
        description,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: HelperMethods().getMyDynamicFontSize(16),
          color: const Color(0xff767676),
        ),
      ),
    );
  }

  Widget pageHeaderText() {
    return Container(
      margin: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(31),
          top: HelperMethods().getMyDynamicHeight(76)),
      child: Text(
        header,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: HelperMethods().getMyDynamicFontSize(24)),
      ),
    );
  }

  Widget divider() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: HelperMethods().getMyDynamicHeight(59)),
          width: HelperMethods().getMyDynamicWidth(202),
          child: const Divider(
            thickness: 3,
            color: Colors.black,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: HelperMethods().getMyDynamicHeight(59)),
          width: HelperMethods().getMyDynamicWidth(188),
          child: const Divider(
            thickness: 0.8,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
