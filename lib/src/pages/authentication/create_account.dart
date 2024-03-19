import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
// import 'package:croshez/helpers/size_config.dart';
// import 'package:croshez/components/back_button.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../helper/common_methods.dart';
import '../../../helper/screen_config.dart';
import 'selection_page.dart';
import '../../../utils/auth_service.dart';
import '../../widgets/form_field.dart';
import '../../widgets/rounded_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode nameFieldFocusNode = FocusNode();
  final FocusNode emailFieldFocusNode = FocusNode();
  final FocusNode passwordFieldFocusNode = FocusNode();
  String emailErrorMesssage = "Required";
  String nameFieldErrorMessage = "Required";

  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isNameValid = true;
  bool _isLoading = false;
  bool isObscured = true;
  bool _disabledButton = true;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final disabledButton = _nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty;
    setState(() {
      _disabledButton = disabledButton;
    });
  }

  bool _validatePassword(String password) {
    final passWordRegex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$');
    return passWordRegex.hasMatch(password);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLayout().init(context);
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          nameFieldFocusNode.unfocus();
          passwordFieldFocusNode.unfocus();
          emailFieldFocusNode.unfocus();
        },
        child: Column(
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
            Padding(
              padding: const EdgeInsets.all(0),
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 3,
                endIndent: HelperMethods().getMyDynamicWidth(290),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(10),
                  left: HelperMethods().getMyDynamicWidth(14),
                  // bottom: HelperMethods().getMyDynamicHeight(10),
                ),
                child: const BackButton(
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: HelperMethods().getMyDynamicHeight(24),
                    left: HelperMethods().getMyDynamicWidth(30),
                    right: HelperMethods().getMyDynamicWidth(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Account",
                        style: GoogleFonts.inter(
                          fontSize: HelperMethods().getMyDynamicFontSize(24),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: HelperMethods().getMyDynamicHeight(24),
                          bottom: HelperMethods().getMyDynamicHeight(24),
                        ),
                        child: Text(
                          "Enter your details to join our thriving crochet community and start your journey today.",
                          style: GoogleFonts.inter(
                            fontSize: HelperMethods().getMyDynamicFontSize(16),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      CustomFormField(
                        fillValue: "Full Name",
                        hinttext: "John Doe",
                        focusNode: nameFieldFocusNode,
                        controller: _nameController,
                        errorPresent: !_isNameValid,
                        errorMessage: nameFieldErrorMessage,
                      ),
                      CustomFormField(
                        fillValue: "Email Address",
                        hinttext: "johndoe@mail.com",
                        focusNode: emailFieldFocusNode,
                        controller: _emailController,
                        errorPresent: !_isEmailValid,
                        errorMessage: emailErrorMesssage,
                      ),
                      CustomFormField(
                        fillValue: "Password",
                        hinttext: "1@6ABcd",
                        controller: _passwordController,
                        focusNode: passwordFieldFocusNode,
                        errorPresent: !_isPasswordValid,
                        obscureText: isObscured,
                        errorMessage:
                            "Should be atleast 6 characters\nShould contain atleast 1 upper case character\nShould contain atleast 1 lower case character\nShould contain atleast 1 digit",
                      ),
                      GestureDetector(
                        onTap: () {
                          isObscured = !isObscured;
                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: HelperMethods().getMyDynamicHeight(8),
                          ),
                          child: Text(
                            isObscured ? 'Show password' : 'Hide password',
                            style: TextStyle(
                              fontSize:
                                  HelperMethods().getMyDynamicFontSize(12),
                              fontWeight: FontWeight.w500,
                              color: Colors.blue.shade300,
                            ),
                          ),
                        ),
                      ),
                      RoundedButton(
                        buttonText: "Next",
                        isLoading: _isLoading,
                        marginLeft: 0,
                        marginTop: 64,
                        onTap: () async {
                          bool isConnected = await Conn().connectivityResult();
                          if (isConnected) {
                            _isLoading = true;
                            setState(() {});
                            SchedulerBinding.instance
                                .addPostFrameCallback((_) async {
                              setState(() {
                                _isNameValid = true;
                                _isEmailValid = true;
                                _isPasswordValid = true;
                                _isLoading = true;
                              });

                              final message = await AuthService().registration(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                                fullname: _nameController.text.trim(),
                              );
                              if (!_validatePassword(
                                  _passwordController.text)) {
                                _isPasswordValid = false;
                                _isLoading = false;
                                setState(() {});
                                return;
                              }
                              if (_nameController.text.trim().isEmpty) {
                                _isNameValid = false;
                                _isLoading = false;
                                setState(() {});
                                return;
                              }
                              if (_nameController.text.trim().length < 3) {
                                nameFieldErrorMessage =
                                    "Must have atleast 3 characters";
                                _isNameValid = false;
                                setState(() {});
                                return;
                              }
                              if (message!.contains('Success')) {
                                Get.offAll(() => const SelectionScreen());
                              } else if (message
                                  .contains('email-already-in-use')) {
                                emailErrorMesssage =
                                    "Already registered with this email";
                                _isEmailValid = false;
                              } else if (message.contains("invalid-email")) {
                                emailErrorMesssage = "Enter a valid email";
                                _isEmailValid = false;
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          } else {
                            const snackBar = SnackBar(
                              content: Text('No Internet'),
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        },
                        backgroundColor: ColorsConfig().kPrimaryColor,
                        disabledButton: _disabledButton,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
