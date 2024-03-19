import 'package:croshez/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/common_methods.dart';

class CustomFormField extends StatelessWidget {
  final List<Function> validators;
  final FocusNode focusNode;
  final String fillValue;
  final String hinttext;
  final TextEditingController controller;
  final String errorMessage;
  final bool errorPresent;
  final EdgeInsetsGeometry? placeHolderMargins;
  final EdgeInsetsGeometry? fieldMargins;
  final bool obscureText;
  const CustomFormField({
    Key? key,
    this.validators = const [],
    required this.focusNode,
    this.fillValue = "",
    this.hinttext = "",
    this.errorMessage = "",
    this.errorPresent = false,
    required this.controller,
    this.obscureText = false,
    this.placeHolderMargins,
    this.fieldMargins,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: placeHolderMargins ??
              EdgeInsets.only(
                top: HelperMethods().getMyDynamicHeight(24),
                bottom: HelperMethods().getMyDynamicHeight(8),
              ),
          child: Text(
            fillValue,
            style: GoogleFonts.inter(
              fontSize: HelperMethods().getMyDynamicFontSize(14),
              fontWeight: FontWeight.w500,
              color: ColorsConfig().fieldIndicatorTextFieldColor,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          width: HelperMethods().getMyDynamicWidth(330),
          margin: fieldMargins,
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              errorText: errorPresent ? errorMessage : null,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsConfig().kPrimaryLightColor, width: 1.0),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              hintText: hinttext,
              hintStyle: GoogleFonts.inter(
                  fontSize: HelperMethods().getMyDynamicFontSize(16),
                  fontWeight: FontWeight.w400,
                  color: ColorsConfig().hintTextColor),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
