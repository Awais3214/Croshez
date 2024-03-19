import 'package:croshez/helper/common_methods.dart';
import 'package:croshez/helper/screen_config.dart';
import 'package:croshez/utils/auth_service.dart';
import 'package:croshez/src/widgets/custom_margins.dart';
import 'package:croshez/src/widgets/form_field.dart';
import 'package:croshez/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dashboard/pages/admin_dashboard_tabs.dart';

class AdminPortalLoginScreen extends StatefulWidget {
  const AdminPortalLoginScreen({super.key});

  @override
  State<AdminPortalLoginScreen> createState() => _AdminPortalLoginScreenState();
}

class _AdminPortalLoginScreenState extends State<AdminPortalLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode emailFieldFocusNode = FocusNode();
  final FocusNode passwordFieldFocusNode = FocusNode();
  bool emailError = false;
  bool passError = false;
  bool isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLayout().init(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: SizedBox(
          width: HelperMethods().getMyDynamicWidth(360),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* Container(
                height: 100,
                width: 100,
                margin: cmargin(
                  bottom: 50,
                ),
                child: Image.asset(
                  'assets/app_logo.png',
                ),
              ), */
              Container(
                width: 500,
                // width: 100,

                margin: cmargin(
                  bottom: 50,
                ),
                child: SvgPicture.asset(
                  "assets/croshez_logo_name.svg",
                ),
              ),
              _textFields(),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: HelperMethods().getMyDynamicHeight(50),
                      decoration: BoxDecoration(
                        color: ColorsConfig().kPrimaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          emailError = false;
                          passError = false;
                          if (isLoading) {
                            return;
                          }

                          if (!_dataIsvalid()) {
                            setState(() {});
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });

                          final String? message = await AuthService().login(
                            email: _emailController.text.trim(),
                            password: _passController.text.trim(),
                          );

                          setState(() {
                            isLoading = false;
                          });

                          if (message!.toLowerCase().contains('admin')) {
                            Get.offAll(const AdminDashboardTabs());
                            return;
                          }

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  message,
                                  style: GoogleFonts.inter(),
                                ),
                              ),
                            );
                          }
                        },
                        child: SizedBox(
                          child: isLoading
                              ? SizedBox(
                                  height:
                                      HelperMethods().getMyDynamicHeight(15),
                                  width: HelperMethods().getMyDynamicHeight(15),
                                  child: const Padding(
                                    padding: EdgeInsets.all(0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Login'.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateEmail(String email) {
    // Use a regular expression to check if the email is valid
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(email);
  }

  bool _dataIsvalid() {
    bool allGood = true;
    if (_emailController.text.trim().isEmpty ||
        !_validateEmail(_emailController.text.trim())) {
      emailError = true;
      allGood = false;
    }
    if (_passController.text.trim().isEmpty ||
        _passController.text.trim().length < 4) {
      passError = true;
      allGood = false;
    }
    if (!allGood) {
      return false;
    }

    return true;
  }

  _textFields() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                child: CustomFormField(
                  focusNode: emailFieldFocusNode,
                  placeHolderMargins: cmargin(
                    bottom: 10,
                  ),
                  controller: _emailController,
                  fillValue: "Email",
                  hinttext: "Email",
                  errorPresent: emailError,
                  errorMessage: 'Invalid email',
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                child: CustomFormField(
                  focusNode: passwordFieldFocusNode,
                  placeHolderMargins: cmargin(
                    bottom: 10,
                    top: 20,
                  ),
                  obscureText: true,
                  fillValue: "Password",
                  controller: _passController,
                  errorPresent: passError,
                  errorMessage: 'Empty password',
                  hinttext: "Password",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
