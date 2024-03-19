import 'dart:developer';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/src/pages/authentication/selection_page.dart';
import 'package:croshez/src/pages/seller/store_page_bottom_navbar.dart';
import 'package:croshez/src/widgets/custom_margins.dart';
import 'package:croshez/utils/constants.dart';
import 'package:croshez/utils/my_shared_preferecnces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helper/common_methods.dart';
import '../../../utils/auth_service.dart';
import '../../../utils/user_services.dart';
import '../../widgets/form_field.dart';
import '../../widgets/rounded_button.dart';
import '../buyer/buyer_home_bottom_navbar.dart';
import '../seller/setup_shop_screen.dart';
import 'age_verification.dart';
import 'create_account.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode emailFieldFocusNode = FocusNode();
  final FocusNode passwordFieldFocusNode = FocusNode();
  bool _disabledButton = true;
  bool emailError = false;
  bool passwordError = false;
  bool _isLoading = false;
  bool googleLoginLoading = false;
  bool isObscured = true;
  String emailErrorMessage = "Invalid email";
  String passwordErrorMessage = "Invalid password";
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _disabledButton = email.isEmpty || password.isEmpty;
    });
  }

  // bool _validateEmail(String email) {
  //   // Use a regular expression to check if the email is valid
  //   final emailRegex = RegExp(
  //       r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
  //   return emailRegex.hasMatch(email);
  // }

  // bool _validatePassword(String password) {
  //   // Check if the password length is greater than 4
  //   return password.length > 4;
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: HelperMethods().getMyDynamicHeight(40),
              ),
              child: const Divider(
                height: 0,
                color: Colors.black,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 3,
                endIndent: HelperMethods().getMyDynamicWidth(290),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: HelperMethods().getMyDynamicHeight(8),
                left: HelperMethods().getMyDynamicWidth(15),
                bottom: HelperMethods().getMyDynamicHeight(0),
              ),
              child: const BackButton(
                color: Colors.black,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: HelperMethods().getMyDynamicHeight(24),
                left: HelperMethods().getMyDynamicWidth(30),
              ),
              child: Text(
                "Sign In",
                style: GoogleFonts.inter(
                    fontSize: HelperMethods().getMyDynamicFontSize(24),
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: HelperMethods().getMyDynamicHeight(20),
                left: HelperMethods().getMyDynamicWidth(30),
                right: HelperMethods().getMyDynamicWidth(31),
              ),
              child: Text(
                "Welcome back! Log in to access your account and continue exploring the world of crochet.",
                style: GoogleFonts.inter(
                    fontSize: HelperMethods().getMyDynamicFontSize(16),
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700),
                textAlign: TextAlign.left,
              ),
            ),
            CustomFormField(
              focusNode: emailFieldFocusNode,
              placeHolderMargins: cmargin(
                top: HelperMethods().getMyDynamicHeight(32),
                left: HelperMethods().getMyDynamicWidth(30),
              ),
              fieldMargins: cmargin(
                left: HelperMethods().getMyDynamicWidth(30),
                top: HelperMethods().getMyDynamicHeight(8),
              ),
              fillValue: "Email",
              hinttext: "Enter your email.",
              controller: _emailController,
              errorPresent: emailError,
              errorMessage: emailErrorMessage,
            ),
            CustomFormField(
              focusNode: passwordFieldFocusNode,
              placeHolderMargins: cmargin(
                top: HelperMethods().getMyDynamicHeight(8),
                left: HelperMethods().getMyDynamicWidth(30),
              ),
              fieldMargins: cmargin(
                left: HelperMethods().getMyDynamicWidth(30),
                top: HelperMethods().getMyDynamicHeight(8),
              ),
              fillValue: "Password",
              hinttext: "Enter your password.",
              controller: _passwordController,
              errorMessage: passwordErrorMessage,
              errorPresent: passwordError,
              obscureText: isObscured,
            ),
            Container(
              margin: EdgeInsets.only(
                left: HelperMethods().getMyDynamicWidth(30),
                right: HelperMethods().getMyDynamicWidth(30),
                top: HelperMethods().getMyDynamicHeight(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      isObscured = !isObscured;
                      setState(() {});
                    },
                    child: Text(
                      isObscured ? 'Show password' : 'Hide password',
                      style: TextStyle(
                        fontSize: HelperMethods().getMyDynamicFontSize(12),
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade300,
                      ),
                    ),
                  ),
                  Text(
                    "Forgot Password?",
                    style: GoogleFonts.inter(
                        fontSize: HelperMethods().getMyDynamicFontSize(12),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            RoundedButton(
              marginTop: 40,
              marginLeft: 30,
              buttonText: "Log In",
              isLoading: _isLoading,
              onTap: () async {
                bool isConnected = await Conn().connectivityResult();
                if (isConnected) {
                  SchedulerBinding.instance.addPostFrameCallback((_) async {
                    if (_disabledButton == false) {
                      setState(() {
                        emailError = false;
                        passwordError = false;
                        _isLoading = true;
                      });
                      final message = await AuthService().login(
                        email: _emailController.text.trim(),
                        password: _passwordController.text,
                      );
                      if (message!.contains('Buyer')) {
                        Get.offAll(() => const BuyerPageBottomNavBar());
                      } else if (message.contains('Seller')) {
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
                      } else if (message.contains(
                          "The getter 'length' was called on null.")) {
                        Get.offAll(() => const SelectionScreen());
                      } else if (message
                          .contains('No user found for that email.')) {
                        emailErrorMessage = "This email is not registered";
                        emailError = true;
                      } else if (message
                          .contains('Wrong password provided for that user.')) {
                        passwordErrorMessage =
                            "Password does not match to this account";
                        passwordError = true;
                      } else if (message.contains("invalid-email")) {
                        emailErrorMessage = "Email address is incorrect";
                        emailError = true;
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  });
                } else {
                  const snackBar = SnackBar(content: Text('No Internet'));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              backgroundColor: ColorsConfig().kPrimaryColor,
              disabledButton: _emailController.text.trim().isEmpty
                  ? true
                  : _passwordController.text.isEmpty
                      ? true
                      : false,
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Get.to(
                    () => const SignUpScreen(),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.topRight,
                  minimumSize: Size.zero,
                ),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "Don't have an account?",
                        style: GoogleFonts.inter(
                            fontSize: HelperMethods().getMyDynamicFontSize(12),
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text: " Create New.",
                        style: GoogleFonts.inter(
                            fontSize: HelperMethods().getMyDynamicFontSize(12),
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: HelperMethods().getMyDynamicHeight(10),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(
                        left: HelperMethods().getMyDynamicWidth(30),
                        right: HelperMethods().getMyDynamicWidth(10)),
                    child: const Divider(),
                  )),
                  Text(
                    "OR",
                    style: TextStyle(
                      fontSize: HelperMethods().getMyDynamicFontSize(12),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: HelperMethods().getMyDynamicWidth(0),
                          right: HelperMethods().getMyDynamicWidth(0)),
                      child: const Divider(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: HelperMethods().getMyDynamicHeight(8),
              ),
              child: RoundedButton(
                marginTop: 24,
                marginLeft: 30,
                buttonText: "Continue with Google",
                isLoading: googleLoginLoading,
                onTap: () async {
                  bool isConnected = await Conn().connectivityResult();
                  if (isConnected) {
                    try {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      setState(() {
                        googleLoginLoading = true;
                      });
                      await AuthService().signInWithGoogle();
                      bool isNewUser = await UserServices().checkNewUser();
                      bool isSignedIn = await _googleSignIn.isSignedIn();
                      if (isSignedIn && isNewUser) {
                        UserServices().createUserInstance();
                        await MySharedPreferecne().saveUserId(
                          auth.currentUser!.uid,
                        );
                        Get.offAll(() => const SelectionScreen());
                      } else if (isSignedIn && isNewUser == false) {
                        List<dynamic> role = await UserServices().getUserRole();
                        await MySharedPreferecne().saveUserId(
                          auth.currentUser!.uid,
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
                    } catch (error) {
                      log(error.toString());
                      setState(() {
                        googleLoginLoading = false;
                      });
                    }
                    setState(() {
                      googleLoginLoading = false;
                    });
                  } else {
                    const snackBar = SnackBar(content: Text('No Internet'));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                backgroundColor: Colors.white,
                textColor: Colors.black,
                isBorder: true,
                loaderColor: ColorsConfig().kPrimaryColor,
                borderColor: ColorsConfig().borderColor,
                isIcon: true,
                icon: 'assets/google_icon.png',
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: HelperMethods().getMyDynamicHeight(8),
            //   ),
            //   child: RoundedButton(
            //     marginTop: 16,
            //     marginLeft: 30,
            //     buttonText: "Continue with Apple",
            //     onTap: () {}, //change name to ontap or onpressed
            //     backgroundColor: Colors.white,
            //     textColor: Colors.black,
            //     isBorder: true,
            //     borderColor: ColorsConfig().borderColor,
            //     isIcon: true,
            //     icon: 'assets/apple_icon.png',
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
