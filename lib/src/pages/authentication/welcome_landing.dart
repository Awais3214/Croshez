import 'dart:developer';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/src/pages/authentication/age_verification.dart';
import 'package:croshez/src/pages/buyer/buyer_home_bottom_navbar.dart';
import 'package:croshez/src/pages/authentication/selection_page.dart';
import 'package:croshez/src/pages/seller/setup_shop_screen.dart';
import 'package:croshez/src/pages/seller/store_page_bottom_navbar.dart';
import 'package:croshez/utils/constants.dart';
import 'package:croshez/utils/my_shared_preferecnces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helper/common_methods.dart';
import '../../../utils/auth_service.dart';
import '../../../utils/user_services.dart';
import '../../widgets/rounded_button.dart';
import 'create_account.dart';
import 'log_in.dart';

class WelcomeLanding extends StatefulWidget {
  const WelcomeLanding({super.key});

  @override
  State<WelcomeLanding> createState() => _WelcomeLandingState();
}

class _WelcomeLandingState extends State<WelcomeLanding> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  String email = '';
  bool? isSignedIn;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool googleSinginLoading = false;
  bool createAccountIsTapped = false;
  bool loginIsTapped = false;
  bool googleSigninIsTapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(40), bottom: 0),
              child: const Divider(
                height: 0,
                color: Colors.black,
                thickness: 1,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(0),
            //   child: Divider(
            //     color: Colors.black,
            //     height: 2,
            //     thickness: 2,
            //     endIndent: HelperMethods().getMyDynamicWidth(290),
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(69.99),
                  left: HelperMethods().getMyDynamicWidth(79),
                  right: HelperMethods()
                      .getMyDynamicWidth(76.82)), // make this responsive
              child: Image.asset('assets/welcome_page_logo.png'),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: HelperMethods().getMyDynamicHeight(32.99),
                left: HelperMethods().getMyDynamicWidth(38),
                right: HelperMethods().getMyDynamicWidth(38),
              ),
              child: Text(
                "Your one-stop marketplace for unique crochet creations and passionate crafters. Dive in and explore!",
                style: GoogleFonts.inter(
                    fontSize: HelperMethods().getMyDynamicFontSize(16),
                    fontWeight: FontWeight.w400,
                    color: ColorsConfig().descriptionTextColor),
                textAlign: TextAlign.center,
              ),
            ),
            RoundedButton(
              marginTop: 32,
              marginLeft: 30,
              buttonText: "Log In to Existing Account",
              onTap: () {
                Get.to(() => const LogInScreen());
              },
              backgroundColor: Colors.white,
              loaderColor: ColorsConfig().kPrimaryColor,
              textColor: const Color(0xFF161616),
              isBorder: true,
              borderColor: ColorsConfig().borderColor,
              disabledButton: loginIsTapped,
            ),
            RoundedButton(
              marginTop: 16,
              marginLeft: 30,
              buttonText: "Create Account",
              onTap: () {
                Get.to(() => const SignUpScreen());
              },
              backgroundColor: ColorsConfig().kPrimaryColor,
              disabledButton: createAccountIsTapped,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: HelperMethods().getMyDynamicHeight(64),
                bottom: HelperMethods().getMyDynamicHeight(7),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: HelperMethods().getMyDynamicWidth(30),
                          right: HelperMethods().getMyDynamicWidth(10)),
                      child: const Divider(),
                    ),
                  ),
                  const Text("OR"),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(
                        left: HelperMethods().getMyDynamicWidth(10),
                        right: HelperMethods().getMyDynamicWidth(30)),
                    child: const Divider(),
                  )),
                ],
              ),
            ),
            RoundedButton(
              marginTop: 25,
              marginLeft: 30,
              buttonText: "Continue with Google",
              onTap: () async {
                setState(() {
                  googleSigninIsTapped = true;
                });
                bool isConnected = await Conn().connectivityResult();
                if (isConnected) {
                  try {
                    setState(() {
                      googleSinginLoading = true;
                    });
                    await AuthService().signInWithGoogle();
                    bool isNewUser = await UserServices().checkNewUser();
                    isSignedIn = await _googleSignIn.isSignedIn();
                    if (isSignedIn! && isNewUser) {
                      UserServices().createUserInstance();
                      await MySharedPreferecne().saveUserId(
                        _auth.currentUser!.uid,
                      );
                      Get.offAll(() => const SelectionScreen());
                    } else if (isSignedIn! && isNewUser == false) {
                      List<dynamic> role = await UserServices().getUserRole();
                      await MySharedPreferecne().saveUserId(
                        _auth.currentUser!.uid,
                      );
                      await MySharedPreferecne().saveUserType(role[0]);
                      if (role[0] == "Seller") {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        int? shopSetup = prefs.getInt('shopSetup');
                        if (shopSetup == 0) {
                          Get.offAll(() => const VerifyAgePage());
                        } else if (shopSetup == 1) {
                          Get.offAll(() => const SetUpShopPage());
                        } else if (shopSetup == 2) {
                          Get.offAll(() => const StorePageBottomNavBar());
                        }
                      } else if (role[0] == 'Buyer') {
                        Get.offAll(() => const BuyerPageBottomNavBar());
                      }
                    }
                    setState(() {
                      googleSinginLoading = false;
                    });
                  } catch (error) {
                    log("Error = $error");
                    setState(() {
                      googleSinginLoading = false;
                    });
                  }
                } else {
                  setState(() {
                    googleSinginLoading = false;
                  });
                  const snackBar = SnackBar(content: Text('No Internet'));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
                googleSigninIsTapped = false;
                setState(() {});
              },
              isLoading: googleSinginLoading,
              backgroundColor: Colors.white,
              loaderColor: Colors.white,
              textColor: Colors.black,
              isBorder: true,
              isIcon: true,
              icon: 'assets/google_icon.png',
              borderColor: ColorsConfig().borderColor,
              disabledButton: googleSigninIsTapped,
            ),
            /* Padding(
              padding: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(8),
                  bottom: HelperMethods().getMyDynamicHeight(40)),
              child: RoundedButton(
                text: "Continue with Apple",
                press: () {}, //change name to ontap or onpressed
                color: Colors.white,
                textColor: Colors.black,
                border: true,
                icon: true,
                icon_path: 'assets/apple_icon.png',
              ),
            ), */
          ],
        ),
      ),
    );
  }
}
