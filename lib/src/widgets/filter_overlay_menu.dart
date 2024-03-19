import 'package:croshez/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import '../../helper/common_methods.dart';
import '../../utils/constants.dart';

class FilterOverlayPage extends StatefulWidget {
  const FilterOverlayPage({
    super.key,
    required this.selectedHookSizes,
    // required this.onConfirmButtonTap});
  });

  final List<String> selectedHookSizes;

  // final Function(List) onConfirmButtonTap;

  @override
  State<FilterOverlayPage> createState() => _FilterOverlayPageState();
}

class _FilterOverlayPageState extends State<FilterOverlayPage> {
  List<String> hookSizes = <String>[
    '2.25 mm',
    '2.75 mm',
    '3.25 mm',
    '3.5 mm',
    '3.75 mm',
    '4 mm',
    '5 mm',
    '5.5 mm',
    '6 mm',
    '6.5 mm',
    '8 mm',
    '9 mm',
    '10 mm'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: HelperMethods().getMyDynamicHeight(30),
                    left: HelperMethods().getMyDynamicWidth(42),
                  ),
                  child: Icon(
                    Icons.filter_alt_outlined,
                    color: ColorsConfig().kPrimaryColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: HelperMethods().getMyDynamicHeight(30),
                    left: HelperMethods().getMyDynamicWidth(10),
                  ),
                  child: Text(
                    'Filters',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: HelperMethods().getMyDynamicFontSize(20),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                widget.selectedHookSizes.clear();
                setState(() {});
              },
              child: Container(
                margin: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(30),
                  right: HelperMethods().getMyDynamicWidth(42),
                ),
                child: Text(
                  'Clear Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: HelperMethods().getMyDynamicFontSize(15),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(15),
            left: HelperMethods().getMyDynamicWidth(46),
          ),
          child: Text(
            'Hook Sizes',
            style: TextStyle(
              fontSize: HelperMethods().getMyDynamicFontSize(16),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(30),
            left: HelperMethods().getMyDynamicWidth(37),
            right: HelperMethods().getMyDynamicWidth(37),
          ),
          child: Wrap(
            children: List.generate(
              hookSizes.length,
              (index) => customChips(
                hookSize: hookSizes[index],
                onTap: () {
                  if (widget.selectedHookSizes.contains(hookSizes[index])) {
                    widget.selectedHookSizes.remove(hookSizes[index]);
                  } else {
                    widget.selectedHookSizes.add(hookSizes[index]);
                  }
                  setState(() {});
                },
                isSelected: widget.selectedHookSizes.contains(
                  hookSizes[index],
                ),
              ),
            ),
          ),
        ),
        RoundedButton(
          buttonText: 'Confirm',
          onTap: () {
            // widget.onConfirmButtonTap(widget.selectedHookSizes);
            Navigator.pop(context, widget.selectedHookSizes);
          },
          marginTop: 15,
          marginLeft: 30,
          textColor: Colors.black,
        ),
      ],
    );
  }

  Widget customChips({String? hookSize, Function? onTap, bool? isSelected}) {
    return Container(
      margin: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(7),
      ),
      child: FilterChip(
        selected: isSelected!,
        label: Text(hookSize!),
        onSelected: (value) {
          onTap!();
        },
        showCheckmark: false,
        backgroundColor: Colors.white,
        selectedColor: ColorsConfig().kPrimaryColor,
      ),
    );
  }
}
