import 'package:croshez/utils/constants.dart';
import 'package:flutter/material.dart';
import '../../helper/common_methods.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final bool? disabledButton;
  final bool? isLoading;
  final bool? isBorder;
  final bool? isIcon;
  final bool? isEmailValid;
  final bool? isPasswordValid;
  final String? icon;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? loaderColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? marginTop;
  final double? marginLeft;
  final Function onTap;

  const RoundedButton({
    Key? key,
    required this.buttonText,
    this.textColor = Colors.white,
    this.borderColor,
    this.backgroundColor,
    this.loaderColor = Colors.white,
    this.height = 48,
    this.width = 330,
    this.borderRadius = 8,
    required this.onTap,
    this.disabledButton = false,
    this.isBorder = false,
    this.isIcon = false,
    this.isLoading = false,
    this.icon,
    required this.marginTop,
    required this.marginLeft,
    this.isEmailValid,
    this.isPasswordValid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabledButton!
          ? null
          : () {
              onTap();
            },
      child: Container(
        height: HelperMethods().getMyDynamicHeight(height!),
        width: HelperMethods().getMyDynamicWidth(width!),
        margin: EdgeInsets.only(
          top: HelperMethods().getMyDynamicHeight(marginTop!),
          left: HelperMethods().getMyDynamicWidth(marginLeft!),
        ),
        decoration: isBorder!
            ? BoxDecoration(
                border: Border.all(width: 1, color: borderColor!),
                borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
                color: disabledButton!
                    ? ColorsConfig().kPrimaryLightColor
                    : backgroundColor)
            : BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
                color: disabledButton!
                    ? ColorsConfig().kPrimaryLightColor
                    : backgroundColor,
              ),
        child: isIcon!
            ? isLoading!
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorsConfig().kPrimaryColor,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: HelperMethods().getMyDynamicWidth(16),
                        ),
                        child: Image.asset(icon!),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: HelperMethods().getMyDynamicWidth(8),
                        ),
                        width: HelperMethods().getMyDynamicWidth(270.66),
                        child: Center(
                          child: Text(
                            buttonText,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontSize:
                                  HelperMethods().getMyDynamicFontSize(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
            : Center(
                child: isLoading!
                    ? CircularProgressIndicator(
                        color: loaderColor,
                      )
                    : Text(
                        buttonText,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: HelperMethods().getMyDynamicFontSize(16),
                        ),
                      ),
              ),
      ),
    );
  }
}
