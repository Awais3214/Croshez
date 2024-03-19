import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/bloc/store_details_bloc/store_details_bloc_bloc.dart';
import 'package:croshez/helper/common_methods.dart';
import 'package:croshez/models/store_model.dart';
import 'package:croshez/src/pages/seller/store_page_bottom_navbar.dart';
import 'package:croshez/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../helper/check_connectivity.dart';

class ShopProfilePage extends StatefulWidget {
  const ShopProfilePage({super.key});

  @override
  State<ShopProfilePage> createState() => _ShopProfilePageState();
}

class _ShopProfilePageState extends State<ShopProfilePage> {
  String imageUrl = '';
  String downloadUrl = '';
  bool isLoading = false;
  bool isNewPicture = false;
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController shopNameFieldController = TextEditingController();
  TextEditingController descriptionFieldController = TextEditingController();
  FocusNode shopNameFieldFocusNode = FocusNode();
  FocusNode descriptionFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        shopNameFieldFocusNode.unfocus();
        descriptionFieldFocusNode.unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        body: BlocBuilder<StoreDetailsBlocBloc, StoreDetailsBlocState>(
          builder: (context, state) {
            if (state is StoreDetailsLoaded) {
              StoreModel store = state.storeDetails!;
              if (store.imageUrl != null) {
                downloadUrl = store.imageUrl!;
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: HelperMethods().getMyDynamicHeight(62),
                          left: HelperMethods().getMyDynamicWidth(30),
                        ),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    //User profile picture
                    profilePictureField(),
                    //Space for user email
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: HelperMethods().getMyDynamicHeight(16),
                          ),
                          child: Text(
                            store.city!,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: HelperMethods().getMyDynamicHeight(540),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Shop Name field
                          fieldIndicator(
                              fieldName: 'Edit Shop Name', topMargin: 51),
                          textField(
                              fieldValue: store.shopName!,
                              controller: shopNameFieldController,
                              focusNode: shopNameFieldFocusNode,
                              maxLines: 1,
                              height: 52),
                          //Shop Description Field
                          fieldIndicator(
                              fieldName: 'Edit Shop Description',
                              topMargin: 18),
                          textField(
                            fieldValue: store.shopDescription!,
                            focusNode: descriptionFieldFocusNode,
                            controller: descriptionFieldController,
                            maxLines: 5,
                            height: 110,
                          ),
                          pageButton(store)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('Error'),
              );
            }
          },
        ),
      ),
    );
  }

  // Widget ageField(StoreModel store) {
  //   return BlocBuilder<UserBlocBloc, UserBlocState>(builder: (context, state) {
  //     if (state is LoadedUserDetails) {
  //       UserModel user = state.userDetails!;
  //       DateTime age = DateTime.fromMillisecondsSinceEpoch(
  //         user.age != null ? user.age!.millisecondsSinceEpoch : 0,
  //       );
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 ageFieldError = false;
  //               });
  //               DatePicker.showDatePicker(
  //                 context,
  //                 initialDateTime: age,
  //                 maxDateTime: DateTime.now(),
  //                 onConfirm: (dateTime, selectedIndex) {
  //                   setState(() {
  //                     editedAge = DateFormat('dd - MM - yyyy').format(dateTime);
  //                   });
  //                   changedAge = dateTime;
  //                 },
  //                 onChange: (dateTime, selectedIndex) {
  //                   setState(() {
  //                     editedAge = DateFormat('dd - MM - yyyy').format(dateTime);
  //                   });
  //                   changedAge = dateTime;
  //                 },
  //                 dateFormat: 'dd MM yyyy',
  //               );
  //             },
  //             child: Container(
  //               height: HelperMethods().getMyDynamicHeight(52),
  //               width: HelperMethods().getMyDynamicWidth(330),
  //               margin: EdgeInsets.only(
  //                 top: HelperMethods().getMyDynamicHeight(4),
  //                 left: HelperMethods().getMyDynamicWidth(30),
  //               ),
  //               padding: EdgeInsets.only(
  //                 top: HelperMethods().getMyDynamicHeight(16),
  //                 left: HelperMethods().getMyDynamicWidth(16),
  //               ),
  //               decoration: BoxDecoration(
  //                 border: Border.all(
  //                   color: ageFieldError
  //                       ? const Color(0xFFB3261E)
  //                       : const Color(0xFF1A444D),
  //                 ),
  //                 borderRadius: BorderRadius.circular(
  //                   HelperMethods().getMyDynamicHeight(8),
  //                 ),
  //               ),
  //               child: Text(
  //                 editedAge == ''
  //                     ? DateFormat('dd - MM - yyyy').format(age)
  //                     : editedAge,
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.w400,
  //                   fontSize: HelperMethods().getMyDynamicFontSize(16),
  //                   color: const Color(0xFF3D3D3D),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           errorText(errorText: 'Must be above 18', errorCheck: ageFieldError),
  //           pageButton(store, user),
  //         ],
  //       );
  //     } else {
  //       return Container();
  //     }
  //   });
  // }

  Future saveNewShopDetailsToDb(StoreModel storeProfile) async {
    bool checkInternetConnectivity = await Conn().connectivityResult();
    if (checkInternetConnectivity) {
      Map<String, dynamic> dataToBeSaved = {};
      File file = File(imageUrl);
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      User user = auth.currentUser!;
      if (imageUrl.isNotEmpty) {
        var snapshot = await firebaseStorage
            .ref()
            .child('images/${user.uid}')
            .putFile(file);
        downloadUrl = await snapshot.ref.getDownloadURL();
      }
      if (shopNameFieldController.text.trim().isNotEmpty) {
        storeProfile.shopName = shopNameFieldController.text.trim();
      }
      // if (changedAge != null) {
      //   DateTime currentYear = DateTime.now();
      //   int difference = currentYear.year - changedAge!.year;
      //   if (difference < 18) {
      //     ageFieldError = true;
      //     setState(() {});
      //     return;
      //   }
      //   dataToBeSaved['age'] = changedAge;
      // }
      // if (changedAge != null) {
      //   userProfile.age = Timestamp.fromDate(changedAge!);
      // }
      if (downloadUrl.isNotEmpty) {
        storeProfile.imageUrl = downloadUrl;
      }
      if (descriptionFieldController.text.trim().isNotEmpty) {
        storeProfile.shopDescription = descriptionFieldController.text.trim();
      }
      if (mounted) {
        context.read<StoreDetailsBlocBloc>().add(
              StoreDetailsLoadedEvent(storeDetails: storeProfile),
            );
      }
      if (descriptionFieldController.text.trim().isNotEmpty) {
        dataToBeSaved['shopDescription'] =
            descriptionFieldController.text.trim();
      }
      if (shopNameFieldController.text.trim().isNotEmpty) {
        dataToBeSaved['shopName'] = shopNameFieldController.text.trim();
      }
      if (imageUrl.isNotEmpty) {
        dataToBeSaved['imageUrl'] = downloadUrl;
      }
      await FirebaseFirestore.instance
          .collection("shop")
          .where("userId", isEqualTo: user.uid)
          .get()
          .then(
        (value) async {
          FirebaseFirestore.instance
              .collection('shop')
              .doc(value.docs[0].id)
              .update(
                dataToBeSaved,
              );
        },
      );
    }
  }

  Widget pageButton(StoreModel storeProfile) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: isLoading
          ? null
          : () async {
              isLoading = true;
              setState(() {});
              // if (ageFieldError) {
              //   isLoading = false;
              //   setState(() {});
              //   return;
              // }
              await saveNewShopDetailsToDb(storeProfile);
              isLoading = false;
              Get.to(
                () => const StorePageBottomNavBar(
                  selectedIndex: 2,
                ),
              );
              // if (!ageFieldError) {
              //   isLoading = false;
              //   Get.to(
              //     () => const StorePageBottomNavBar(
              //       selectedIndex: 2,
              //     ),
              //   );
              // }
            },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: HelperMethods().getMyDynamicHeight(48),
          width: HelperMethods().getMyDynamicWidth(330),
          decoration: BoxDecoration(
            color: ColorsConfig().kPrimaryColor,
            borderRadius: BorderRadius.circular(
              HelperMethods().getMyDynamicHeight(6),
            ),
          ),
          margin: EdgeInsets.only(
            top: HelperMethods().getMyDynamicHeight(210),
          ),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    'Save Changes',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: HelperMethods().getMyDynamicFontSize(16),
                        fontWeight: FontWeight.w500),
                  ),
          ),
        ),
      ),
    );
  }

  Widget fieldIndicator(
      {required String fieldName, required double topMargin}) {
    return Container(
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(topMargin),
        left: HelperMethods().getMyDynamicWidth(34),
      ),
      child: Text(
        fieldName,
        style: TextStyle(
          fontSize: HelperMethods().getMyDynamicFontSize(14),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget errorText({required String errorText, required bool errorCheck}) {
    return Visibility(
      visible: errorCheck,
      child: Container(
        margin: EdgeInsets.only(
          top: HelperMethods().getMyDynamicHeight(4),
          left: HelperMethods().getMyDynamicWidth(34),
        ),
        child: Text(
          errorText,
          style: TextStyle(
            fontSize: HelperMethods().getMyDynamicFontSize(14),
            fontWeight: FontWeight.w500,
            color: const Color(0xFFB3261E),
          ),
        ),
      ),
    );
  }

  Widget textField({
    required String fieldValue,
    required FocusNode focusNode,
    required TextEditingController controller,
    required int maxLines,
    required double height,
  }) {
    return Container(
      height: HelperMethods().getMyDynamicHeight(height),
      width: HelperMethods().getMyDynamicWidth(330),
      margin: EdgeInsets.only(
        top: HelperMethods().getMyDynamicHeight(4),
        left: HelperMethods().getMyDynamicWidth(30),
      ),
      padding: EdgeInsets.only(
        left: HelperMethods().getMyDynamicWidth(16),
        bottom: HelperMethods().getMyDynamicHeight(6),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF1A444D),
        ),
        borderRadius: BorderRadius.circular(
          HelperMethods().getMyDynamicHeight(8),
        ),
      ),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: HelperMethods().getMyDynamicFontSize(16),
          color: const Color(0xFF3D3D3D),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: fieldValue,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: HelperMethods().getMyDynamicFontSize(16),
            color: const Color(0xFF3D3D3D),
          ),
        ),
      ),
    );
  }

  Widget profilePictureField() {
    return BlocBuilder<StoreDetailsBlocBloc, StoreDetailsBlocState>(
      builder: (context, state) {
        if (state is StoreDetailsLoaded) {
          if (state.storeDetails!.imageUrl != null) {
            downloadUrl = state.storeDetails!.imageUrl!;
          }
          if (isNewPicture) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    uploadFromCameraOrGalleryDialog(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: HelperMethods().getMyDynamicHeight(150),
                        width: HelperMethods().getMyDynamicHeight(150),
                        margin: EdgeInsets.only(
                          top: HelperMethods().getMyDynamicHeight(21),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            100,
                          ),
                          child: Image.file(
                            File(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            100,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(
                              HelperMethods().getMyDynamicHeight(2),
                            ),
                            color: ColorsConfig().kPrimaryColor,
                            child: const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
          if (downloadUrl.isEmpty) {
            if (!isNewPicture) {
              return GestureDetector(
                onTap: () {
                  uploadFromCameraOrGalleryDialog(context);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: HelperMethods().getMyDynamicHeight(53),
                    left: HelperMethods().getMyDynamicWidth(145),
                  ),
                  child: Image.asset(
                    'assets/profile_avatar.png',
                    fit: BoxFit.contain,
                  ),
                ),
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      uploadFromCameraOrGalleryDialog(context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: HelperMethods().getMyDynamicHeight(150),
                          width: HelperMethods().getMyDynamicHeight(150),
                          margin: EdgeInsets.only(
                            top: HelperMethods().getMyDynamicHeight(21),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              100,
                            ),
                            child: Image.file(
                              File(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              100,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(
                                HelperMethods().getMyDynamicHeight(2),
                              ),
                              color: ColorsConfig().kPrimaryColor,
                              child: const Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    uploadFromCameraOrGalleryDialog(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: HelperMethods().getMyDynamicHeight(150),
                        width: HelperMethods().getMyDynamicHeight(150),
                        margin: EdgeInsets.only(
                          top: HelperMethods().getMyDynamicHeight(21),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            100,
                          ),
                          child: Image.network(
                            downloadUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            100,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(
                              HelperMethods().getMyDynamicHeight(2),
                            ),
                            color: ColorsConfig().kPrimaryColor,
                            child: const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
        } else {
          return Container();
        }
      },
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
                        source: ImageSource.camera,
                        imageQuality: 10,
                        preferredCameraDevice: CameraDevice.front,
                        // maxHeight: HelperMethods().getMyDynamicHeight(100),
                        // maxWidth: HelperMethods().getMyDynamicWidth(100),
                      );
                      isNewPicture = true;
                      imageUrl = imagePath!.path;
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
                      XFile? imagePath = await _imagePicker.pickImage(
                          source: ImageSource.gallery, imageQuality: 10);
                      isNewPicture = true;
                      imageUrl = imagePath!.path;
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
                              left: HelperMethods().getMyDynamicWidth(5),
                            ),
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
}
