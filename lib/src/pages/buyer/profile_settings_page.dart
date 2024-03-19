import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/helper/common_methods.dart';
import 'package:croshez/src/pages/buyer/buyer_home_bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../bloc/user_details_bloc/user_bloc_bloc.dart';
import '../../../helper/check_connectivity.dart';
import '../../../models/user_model.dart';
import '../../../utils/constants.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  String imageUrl = '';
  String downloadUrl = '';
  bool isNewPicture = false;
  bool isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  FocusNode nameFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nameFieldFocusNode.unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        body: BlocBuilder<UserBlocBloc, UserBlocState>(
          builder: (context, state) {
            if (state is LoadedUserDetails) {
              UserModel user = state.userDetails!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
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
                            user.email!,
                          ),
                        ),
                      ],
                    ),
                    //Name field
                    fieldIndicator(fieldName: 'Edit Name', topMargin: 101),
                    nameField(user),
                    //Save chagnes button
                    pageButton(user),
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

  Future saveNewUserDetailsToDb(UserModel userProfile) async {
    bool checkInternetConnectivity = await Conn().connectivityResult();
    if (checkInternetConnectivity) {
      Map<Object, Object?> requestBody = {};
      if (nameController.text.trim().isNotEmpty) {
        requestBody['fullname'] = nameController.text.trim();
      }
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      User user = auth.currentUser!;

      if (imageUrl.isNotEmpty) {
        File file = File(imageUrl);
        var snapshot = await firebaseStorage
            .ref()
            .child('images/${user.uid}')
            .putFile(file);
        downloadUrl = await snapshot.ref.getDownloadURL();
        requestBody['profilePicture'] = downloadUrl;
      }

      await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
            requestBody,
          );
      if (nameController.text.trim().isNotEmpty) {
        userProfile.fullname = nameController.text.trim();
      }
      if (downloadUrl.isNotEmpty) {
        userProfile.profilePicture = downloadUrl;
      }
      if (mounted) {
        context.read<UserBlocBloc>().add(
              UserLoadedEvent(userDetails: userProfile),
            );
      }
    }
  }

  Widget pageButton(UserModel userProfile) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: isLoading
          ? null
          : () async {
              if (nameController.text.trim().isEmpty && imageUrl.isEmpty) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No Changes To Be Saved'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
                return;
              }
              isLoading = true;
              setState(() {});
              await saveNewUserDetailsToDb(userProfile);
              Get.off(() => const BuyerPageBottomNavBar(
                    selectedIndex: 2,
                  ));
              isLoading = false;
            },
      child: Container(
        height: HelperMethods().getMyDynamicHeight(48),
        width: HelperMethods().getMyDynamicWidth(330),
        margin: EdgeInsets.only(
          top: HelperMethods().getMyDynamicHeight(320),
          left: HelperMethods().getMyDynamicWidth(30),
        ),
        decoration: BoxDecoration(
          color: ColorsConfig().kPrimaryColor,
          borderRadius: BorderRadius.circular(
            HelperMethods().getMyDynamicHeight(6),
          ),
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

  Widget nameField(UserModel user) {
    return Container(
      height: HelperMethods().getMyDynamicHeight(52),
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
        focusNode: nameFieldFocusNode,
        controller: nameController,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: HelperMethods().getMyDynamicFontSize(16),
          color: const Color(0xFF3D3D3D),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: user.fullname,
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
    return BlocBuilder<UserBlocBloc, UserBlocState>(
      builder: (context, state) {
        if (state is LoadedUserDetails) {
          if (state.userDetails!.profilePicture != null) {
            downloadUrl = state.userDetails!.profilePicture!;
          }
          if (isNewPicture) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
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
                      bool galleryPermissions =
                          await Permission.mediaLibrary.request().isGranted;
                      if (galleryPermissions) {
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                        XFile? imagePath = await _imagePicker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 10,
                        );
                        isNewPicture = true;
                        imageUrl = imagePath!.path;
                        setState(() {});
                      }
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
