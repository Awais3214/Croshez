import 'package:croshez/admin/auth/admin_login_screen.dart';
import 'package:croshez/admin/dashboard/pages/admin_dashboard_tabs.dart';
import 'package:croshez/src/pages/authentication/age_verification.dart';
import 'package:croshez/src/pages/authentication/selection_page.dart';
import 'package:croshez/src/pages/buyer/buyer_home_bottom_navbar.dart';
import 'package:croshez/src/pages/seller/setup_shop_screen.dart';
import 'package:croshez/src/pages/seller/store_page_bottom_navbar.dart';
import 'package:croshez/src/pages/authentication/welcome_landing.dart';
import 'package:croshez/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper/screen_config.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  checking,
  notSignedIn,
  signedInUser,
}

class _RootPageState extends State<RootPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  AuthStatus authStatus = AuthStatus.checking;
  late SharedPreferences prefs;
  String? userType;
  int? shopSetup;

  @override
  void initState() {
    checkingAlreadyLoggedIn();
    super.initState();
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    AppLayout().init(context);
    switch (authStatus) {
      case AuthStatus.checking:
        return CircularProgressIndicator(
          color: ColorsConfig().kPrimaryColor,
        );
      case AuthStatus.notSignedIn:
        if (kIsWeb) {
          return const AdminPortalLoginScreen();
        }
        return const WelcomeLanding();

      case AuthStatus.signedInUser:
        if (userType == 'Seller') {
          if (shopSetup == 0) {
            return const VerifyAgePage();
          } else if (shopSetup == 1) {
            return const SetUpShopPage();
          } else if (shopSetup == 2) {
            return const StorePageBottomNavBar();
          } else {
            return const StorePageBottomNavBar();
          }
        } else if (userType == 'Buyer') {
          return const BuyerPageBottomNavBar();
        } else if (userType == 'admin') {
          return const AdminDashboardTabs();
        } else if (userType == null) {
          return const SelectionScreen();
        } else {
          if (kIsWeb) {
            return const AdminPortalLoginScreen();
          }
          return const WelcomeLanding();
        }
    }
  }

  checkingAlreadyLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? documentId = prefs.getString('documentId');
    userType = prefs.getString('userType');
    shopSetup = prefs.getInt('shopSetup');
    // String? userAge = prefs.getString('userAge');
    if (documentId != null && userType != null) {
      _updateAuthStatus(AuthStatus.signedInUser);
    } else {
      _updateAuthStatus(AuthStatus.notSignedIn);
    }
  }
}
