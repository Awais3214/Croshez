import 'dart:io';

import 'package:croshez/helper/common_methods.dart';
import 'package:croshez/src/pages/seller/preview_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/constants.dart';

class UploadProductPage extends StatefulWidget {
  const UploadProductPage({super.key});

  @override
  State<UploadProductPage> createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  List<String> imageUrl = [];
  final ImagePicker _imagePicker = ImagePicker();
  String header = 'Add Your First Product';
  String description =
      'Showcase your crochet creations! Add details and photos of your first item to attract buyers.';
  String pictureFieldIndicatorText = 'Upload Photos (Upto 6)';
  String productNameFieldHintText = "Enter your product’s name";
  String productDescriptionFieldHintText = "Enter the product’s description";
  String priceFieldHintText = 'Enter price';
  String hookSizeFieldHintText = 'Pick size';
  String productNameFieldIndicator = 'Product Name';
  String productDescriptionFieldIndicator = 'Product Description';
  String priceFieldIndicator = 'Price';
  String hookSizeFieldIndicator = 'Hook Size';
  String buttonText = 'Preview Posting';
  String userShopDocumentId = '';
  TextEditingController productName = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController price = TextEditingController();
  String userInputHookSize = '';
  bool productNameError = false;
  bool productDescriptionError = false;
  bool priceError = false;
  bool hookSizeError = false;
  bool pictureError = false;
  FocusNode focusNodeProductName = FocusNode();
  FocusNode focusNodeProductDescription = FocusNode();
  FocusNode focusNodePrice = FocusNode();
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
  bool isTapped = false;

  @override
  void dispose() {
    productDescription.dispose();
    productName.dispose();
    price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backArrowIcon(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pageHeaderText(),
                descriptionText(),
                inputFieldIndicatorText(pictureFieldIndicatorText,
                    topMargin: 43),
                uploadPhotosContainer(context),
                deleteImagesText(),
                errorMessage(pictureError),
                inputFieldIndicatorText(productNameFieldIndicator,
                    topMargin: imageUrl.isEmpty ? 16 : 21),
                inputField(
                    hintText: productNameFieldHintText,
                    controller: productName,
                    errorCheck: productNameError,
                    focusNode: focusNodeProductName,
                    onTap: () {
                      productNameError = false;
                      setState(() {});
                    }),
                errorMessage(productNameError),
                inputFieldIndicatorText(productDescriptionFieldIndicator),
                inputField(
                    hintText: productDescriptionFieldHintText,
                    controller: productDescription,
                    errorCheck: productDescriptionError,
                    focusNode: focusNodeProductDescription,
                    onTap: () {
                      productDescriptionError = false;
                      setState(() {});
                    },
                    maxLines: 5,
                    height: 110),
                errorMessage(productDescriptionError),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        inputFieldIndicatorText(priceFieldIndicator),
                        inputField(
                          hintText: priceFieldHintText,
                          controller: price,
                          errorCheck: priceError,
                          focusNode: focusNodePrice,
                          onTap: () {
                            priceError = false;
                            setState(() {});
                          },
                          width: 152,
                          isPriceField: true,
                        ),
                        errorMessage(
                          priceError,
                          priceLimitCheck: price.text.trim(),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        inputFieldIndicatorText(hookSizeFieldIndicator),
                        dropDownField(
                          hintText: hookSizeFieldHintText,
                          width: 152,
                          leftMargin: 26,
                          onTap: () {
                            hookSizeError = false;
                            setState(() {});
                          },
                        ),
                        errorMessage(hookSizeError),
                      ],
                    ),
                  ],
                ),
                previewButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadFromCameraOrGalleryDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Choose Where You Want To Upload Photos From',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: HelperMethods().getMyDynamicHeight(150),
            child: Column(
              children: [
                SizedBox(
                  width: HelperMethods().getMyDynamicWidth(150),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      XFile? imagePath = await _imagePicker.pickImage(
                          source: ImageSource.camera, imageQuality: 10);
                      imageUrl.add(imagePath!.path);
                      setState(() {});
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        ColorsConfig().kPrimaryColor,
                      ),
                    ),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                right: HelperMethods().getMyDynamicWidth(5)),
                            child: const Icon(Icons.camera),
                          ),
                          const Text('Camera'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: HelperMethods().getMyDynamicWidth(150),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      List<XFile>? imagePath =
                          await _imagePicker.pickMultiImage(imageQuality: 10);
                      for (int i = 0; i < imagePath.length; i++) {
                        imageUrl.add(imagePath[i].path);
                      }
                      if (imageUrl.length > 6) {
                        for (int i = 6; i < imageUrl.length; i++) {
                          imageUrl.removeAt(i);
                        }
                      }
                      setState(() {});
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        ColorsConfig().kPrimaryColor,
                      ),
                    ),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/gallery-icon.png',
                            color: Colors.white,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: HelperMethods().getMyDynamicWidth(5)),
                            child: const Text('Gallery'),
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
      },
    );
  }

  Widget errorMessage(bool errorCheck, {String priceLimitCheck = "10"}) {
    String errorMessage = 'Required';
    if (price.text.length < 6) {
      if (int.tryParse(priceLimitCheck) != null) {
        if (int.tryParse(priceLimitCheck)! < 10) {
          errorMessage = 'Must be atleast 10';
        }
        if (int.tryParse(priceLimitCheck)! > 99999) {
          errorMessage = 'Must be less than 99999';
        }
      }
    } else {
      errorMessage = 'Must be less than 99999';
    }

    return Visibility(
      visible: errorCheck,
      child: Container(
        margin: EdgeInsets.only(
          top: HelperMethods().getMyDynamicHeight(4),
          left: HelperMethods().getMyDynamicWidth(35),
        ),
        child: Text(
          errorMessage,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: HelperMethods().getMyDynamicFontSize(12),
            color: const Color(0xFFB3261E),
          ),
        ),
      ),
    );
  }

  Widget previewButton() {
    return GestureDetector(
      onTap: isTapped
          ? null
          : () {
              isTapped = true;
              if (imageUrl.isEmpty) {
                pictureError = true;
              } else if (productName.text.trim().isEmpty) {
                productNameError = true;
              } else if (productDescription.text.trim().isEmpty) {
                productDescriptionError = true;
              } else if (price.text.trim().isEmpty ||
                  price.text.trim().length < 2 ||
                  price.text.trim().length > 5) {
                priceError = true;
              } else if (userInputHookSize.isEmpty || userInputHookSize == '') {
                hookSizeError = true;
              } else {
                productName.text.trim();
                productDescription.text.trim();
                price.text.trim();
                Get.to(
                  () => PreviewProductScreen(
                    imageUrl: imageUrl,
                    hookSize: userInputHookSize,
                    productDetails: productDescription.text.trim(),
                    productName: productName.text.trim(),
                    productPrice: price.text.trim(),
                    buttonText: 'Upload',
                  ),
                );
              }
              isTapped = false;
              setState(() {});
            },
      child: Container(
        height: HelperMethods().getMyDynamicHeight(48),
        width: HelperMethods().getMyDynamicWidth(330),
        margin: EdgeInsets.only(
          top: imageUrl.isEmpty
              ? HelperMethods().getMyDynamicHeight(36)
              : HelperMethods().getMyDynamicHeight(60),
          left: HelperMethods().getMyDynamicWidth(30),
          bottom: HelperMethods().getMyDynamicHeight(20),
        ),
        decoration: BoxDecoration(
          color: imageUrl.isEmpty
              ? ColorsConfig().kPrimaryLightColor
              : productName.text.trim().isEmpty
                  ? ColorsConfig().kPrimaryLightColor
                  : productDescription.text.trim().isEmpty
                      ? ColorsConfig().kPrimaryLightColor
                      : price.text.trim().isEmpty
                          ? ColorsConfig().kPrimaryLightColor
                          : price.text.trim().length < 2
                              ? ColorsConfig().kPrimaryLightColor
                              : price.text.trim().length > 5
                                  ? ColorsConfig().kPrimaryLightColor
                                  : userInputHookSize.isEmpty
                                      ? ColorsConfig().kPrimaryLightColor
                                      : userInputHookSize == ''
                                          ? ColorsConfig().kPrimaryLightColor
                                          : ColorsConfig().kPrimaryColor,
          borderRadius: BorderRadius.circular(
            HelperMethods().getMyDynamicHeight(6),
          ),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
                color: Colors.white,
                fontSize: HelperMethods().getMyDynamicFontSize(16),
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget dropDownField(
      {required String hintText,
      double height = 52,
      double width = 330,
      double leftMargin = 31,
      required Function? onTap}) {
    return Container(
      width: HelperMethods().getMyDynamicWidth(width),
      height: HelperMethods().getMyDynamicHeight(height),
      margin: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(leftMargin),
        top: HelperMethods().getMyDynamicHeight(8),
      ),
      padding: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(16),
        bottom: HelperMethods().getMyDynamicHeight(3),
        right: HelperMethods().getMyDynamicWidth(10),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              hookSizeError ? const Color(0xFFB3261E) : const Color(0xffD9D9D9),
        ),
        borderRadius: BorderRadius.circular(
          HelperMethods().getMyDynamicHeight(8),
        ),
      ),
      child: DropdownButton(
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: const Color(0xff9E9E9E),
          size: HelperMethods().getMyDynamicFontSize(20),
        ),
        underline: const SizedBox(),
        hint: userInputHookSize == ''
            ? Text(
                hintText,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: HelperMethods().getMyDynamicFontSize(16),
                  color: const Color(0xFF3D3D3D).withOpacity(0.5),
                ),
              )
            : Text(
                userInputHookSize,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: HelperMethods().getMyDynamicFontSize(16),
                  color: const Color(0xFF000000),
                ),
              ),
        onChanged: (value) {
          setState(() {
            userInputHookSize = value ?? '';
          });
        },
        items: hookSizes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget inputField({
    required String hintText,
    required TextEditingController controller,
    required bool errorCheck,
    required FocusNode focusNode,
    required Function? onTap,
    int maxLines = 1,
    double height = 52,
    double width = 330,
    double leftMargin = 31,
    bool isPriceField = false,
  }) {
    return Container(
      width: HelperMethods().getMyDynamicWidth(width),
      height: HelperMethods().getMyDynamicHeight(height),
      margin: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(leftMargin),
        top: HelperMethods().getMyDynamicHeight(8),
      ),
      padding: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(16),
        bottom: HelperMethods().getMyDynamicHeight(6),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: focusNode.hasFocus
              ? const Color(0xFF1A444D)
              : errorCheck
                  ? const Color(0xFFB3261E)
                  : const Color(0xFFD9D9D9),
        ),
        borderRadius: BorderRadius.circular(
          HelperMethods().getMyDynamicHeight(8),
        ),
      ),
      child: TextField(
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
        onTapOutside: (event) {
          focusNode.unfocus();
        },
        focusNode: focusNode,
        controller: controller,
        keyboardType: isPriceField ? TextInputType.number : null,
        inputFormatters: isPriceField
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ]
            : null,
        style: const TextStyle(),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: HelperMethods().getMyDynamicFontSize(16),
            color: const Color(0xff3D3D3D).withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget uploadPhotosContainer(BuildContext context) {
    if (imageUrl.isEmpty) {
      return GestureDetector(
        onTap: () {
          pictureError = false;
          setState(() {});
          uploadFromCameraOrGalleryDialog(context);
        },
        child: Container(
          height: HelperMethods().getMyDynamicHeight(110),
          margin: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(30),
            top: HelperMethods().getMyDynamicHeight(8),
            right: HelperMethods().getMyDynamicWidth(30),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            border: Border.all(
              color: pictureError
                  ? const Color(0xFFB3261E)
                  : const Color(0xFFD9D9D9),
            ),
            borderRadius: BorderRadius.circular(
              HelperMethods().getMyDynamicHeight(8),
            ),
          ),
          child: Center(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: HelperMethods().getMyDynamicWidth(102),
                  ),
                  child: const Icon(Icons.add_circle_outline_sharp),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: HelperMethods().getMyDynamicWidth(8),
                  ),
                  child: Text(
                    'Upload Photos',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: HelperMethods().getMyDynamicFontSize(14),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: HelperMethods().getMyDynamicHeight(60),
        width: HelperMethods().getMyDynamicWidth(330),
        margin: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(30),
          right: HelperMethods().getMyDynamicWidth(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: imageUrl.length + 1,
                itemBuilder: (context, index) {
                  if (index == imageUrl.length) {
                    return GestureDetector(
                      onTap: () async {
                        List<XFile>? imagePath =
                            await _imagePicker.pickMultiImage(imageQuality: 10);
                        for (int i = 0; i < imagePath.length; i++) {
                          if (i >= 6) {
                            break;
                          }
                          imageUrl.add(imagePath[i].path);
                        }
                        if (imageUrl.length > 6) {
                          for (int i = 6; i < imageUrl.length; i++) {
                            imageUrl.removeAt(i);
                          }
                        }
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: HelperMethods().getMyDynamicHeight(10),
                        ),
                        child: const Icon(Icons.add_circle_outline),
                      ),
                    );
                  } else {
                    int value = 0;
                    if (index < imageUrl.length) {
                      value = index;
                    }
                    return GestureDetector(
                      onLongPress: () {
                        imageUrl.removeAt(index);
                        setState(() {});
                      },
                      child: Container(
                        height: HelperMethods().getMyDynamicHeight(48),
                        width: HelperMethods().getMyDynamicWidth(47.02),
                        margin: EdgeInsets.only(
                          right: HelperMethods().getMyDynamicWidth(8.98),
                          top: HelperMethods().getMyDynamicHeight(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              HelperMethods().getMyDynamicHeight(3),
                            ),
                          ),
                          child: Image.file(
                            File(imageUrl[value]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget deleteImagesText() {
    if (imageUrl.isEmpty) {
      return Visibility(
        visible: false,
        child: Container(
          margin: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(31),
            top: HelperMethods().getMyDynamicHeight(4),
          ),
          child: const Text('Press hold to delete images'),
        ),
      );
    } else {
      return Visibility(
        visible: true,
        child: Container(
          margin: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(31),
            top: HelperMethods().getMyDynamicHeight(4),
          ),
          child: Text(
            'Press hold to delete images',
            style: TextStyle(
                fontSize: HelperMethods().getMyDynamicFontSize(10),
                fontWeight: FontWeight.w400,
                color: ColorsConfig().descriptionTextColor),
          ),
        ),
      );
    }
  }

  Widget inputFieldIndicatorText(String indicatorText,
      {double topMargin = 16}) {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(topMargin),
        left: HelperMethods().getMyDynamicWidth(30),
      ),
      child: Text(
        indicatorText,
        style: TextStyle(
          fontSize: HelperMethods().getMyDynamicFontSize(14),
          fontWeight: FontWeight.w500,
          color: const Color(0xff3D3D3D),
        ),
      ),
    );
  }

  Widget descriptionText() {
    return Container(
      margin: EdgeInsets.only(
          left: HelperMethods().getMyDynamicWidth(31),
          right: HelperMethods().getMyDynamicWidth(52),
          top: HelperMethods().getMyDynamicHeight(24)),
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
          left: HelperMethods().getMyDynamicWidth(26),
          top: HelperMethods().getMyDynamicHeight(31)),
      child: Text(
        header,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: HelperMethods().getMyDynamicFontSize(24)),
      ),
    );
  }

  Widget backArrowIcon() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.back();
      },
      child: Container(
        margin: EdgeInsets.only(
            left: HelperMethods().getMyDynamicWidth(23),
            top: HelperMethods().getMyDynamicHeight(42.57)),
        padding: EdgeInsets.symmetric(
            horizontal: HelperMethods().getMyDynamicWidth(4),
            vertical: HelperMethods().getMyDynamicHeight(4)),
        child: const Icon(IconData(0xe092,
            fontFamily: 'MaterialIcons', matchTextDirection: true)),
      ),
    );
  }
}
