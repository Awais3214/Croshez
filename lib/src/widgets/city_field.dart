import 'package:flutter/material.dart';

import '../../helper/common_methods.dart';

class MyCityField extends StatelessWidget {
  final String cityFieldHintText;
  final FocusNode focusNodeShopCity;
  final bool shopCityError;
  final String? userInputShopcity;
  final Function onTap;
  final Function onChanged;
  MyCityField({
    super.key,
    required this.focusNodeShopCity,
    required this.cityFieldHintText,
    required this.shopCityError,
    required this.userInputShopcity,
    required this.onTap,
    required this.onChanged,
  });

  final List<String> cities = <String>[
    'Lahore',
    'Multan',
    'Islamabad',
    'Faislabad',
    'Hyderabad',
    'Karachi'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HelperMethods().getMyDynamicWidth(330),
      height: HelperMethods().getMyDynamicHeight(52),
      margin: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(30),
        top: HelperMethods().getMyDynamicHeight(8),
      ),
      padding: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(16),
        bottom: HelperMethods().getMyDynamicHeight(3),
        right: HelperMethods().getMyDynamicWidth(10),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: focusNodeShopCity.hasFocus
              ? const Color(0xFF1A444D)
              : shopCityError
                  ? const Color(0xFFB3261E)
                  : const Color(0xFFD9D9D9),
        ),
        borderRadius: BorderRadius.circular(
          HelperMethods().getMyDynamicHeight(8),
        ),
      ),
      child: DropdownButton(
        onTap: () {
          onTap;
        },
        focusNode: focusNodeShopCity,
        value: userInputShopcity,
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: const Color(0xff9E9E9E),
          size: HelperMethods().getMyDynamicFontSize(20),
        ),
        underline: const SizedBox(),
        hint: Text(
          cityFieldHintText,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: HelperMethods().getMyDynamicFontSize(16),
            color: const Color(0xff3D3D3D).withOpacity(0.5),
          ),
        ),
        onChanged: (value) {
          onChanged(value);
        },
        items: cities.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
