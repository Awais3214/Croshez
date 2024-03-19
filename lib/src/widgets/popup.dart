import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/common_methods.dart';
import '../../utils/constants.dart';

class MyPopUpDialog extends StatelessWidget {
  final String popupText;
  final String popupTitle;
  final String continueText;
  final String cancelText;

  final VoidCallback? pressContinue;
  final VoidCallback? pressCancel;

  const MyPopUpDialog({
    Key? key,
    this.popupText = "pop up text",
    this.popupTitle = "pop up title",
    this.continueText = "continue text",
    this.cancelText = "cancel text",
    this.pressCancel,
    this.pressContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
      onPressed: pressCancel,
      child: Text(
        cancelText,
        style: GoogleFonts.inter(
          fontSize: HelperMethods().getMyDynamicFontSize(14),
          fontWeight: FontWeight.w500,
          color: ColorsConfig().kPrimaryColor,
        ),
      ),
    );
    Widget continueButton = TextButton(
      onPressed: pressContinue,
      child: Text(
        continueText,
        style: GoogleFonts.inter(
          fontSize: HelperMethods().getMyDynamicFontSize(14),
          fontWeight: FontWeight.w500,
          color: ColorsConfig().kPrimaryColor,
        ),
      ),
    );

    // set up the AlertDialog
    return AlertDialog(
      title: Text(popupTitle),
      content: Text(
        popupText,
        style: GoogleFonts.inter(
          fontSize: HelperMethods().getMyDynamicFontSize(14),
          fontWeight: FontWeight.w400,
          // color: ColorsConfig().kPrimaryColor,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11),
      ),
    );
  }
}
