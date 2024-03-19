import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/helper/common_methods.dart';
import 'package:croshez/src/pages/seller/seller_profile_page.dart';
import 'package:croshez/src/pages/seller/store_page.dart';
import 'package:croshez/utils/seller_services.dart';
import 'package:croshez/utils/constants.dart';
import 'package:flutter/material.dart';
import '../../../utils/my_shared_preferecnces.dart';
import 'orders_page.dart';

class StorePageBottomNavBar extends StatefulWidget {
  final int selectedIndex;

  const StorePageBottomNavBar({
    Key? key,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  State<StorePageBottomNavBar> createState() => _StorePageBottomNavBarState();
}

class _StorePageBottomNavBarState extends State<StorePageBottomNavBar> {
  late int selectedIndex;

  @override
  void initState() {
    MySharedPreferecne().saveUserType('Seller');
    MySharedPreferecne().saveShopSetupStage(2);
    Conn().connectivityResult().then((value) {
      if (value) {
        SellerServices().getStoreDetails(context);
        SellerServices().getOrderData(context);
        SellerServices().getProductList(context);
      } else {
        const snackBar = SnackBar(content: Text('No Internet'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  static final List<Widget> widgetOptions = <Widget>[
    const StorePage(),
    const OrdersPage(),
    const SellerProfilePage(),
  ];

  void changeIndexOnTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: changeIndexOnTap,
        elevation: 10,
        useLegacyColorScheme: false,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: HelperMethods().getMyDynamicFontSize(12),
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1D1B20),
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: HelperMethods().getMyDynamicFontSize(12),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1D1B20),
        ),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              height: HelperMethods().getMyDynamicHeight(32),
              width: HelperMethods().getMyDynamicWidth(64),
              margin: EdgeInsets.only(
                top: HelperMethods().getMyDynamicHeight(12),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    HelperMethods().getMyDynamicHeight(16),
                  ),
                  color: selectedIndex == 0
                      ? ColorsConfig().kPrimaryColor
                      : Colors.white),
              child: Icon(
                Icons.store_outlined,
                color:
                    selectedIndex == 0 ? Colors.white : const Color(0xFF5F5F5F),
              ),
            ),
            label: 'Store',
          ),
          BottomNavigationBarItem(
              icon: Container(
                height: HelperMethods().getMyDynamicHeight(32),
                width: HelperMethods().getMyDynamicWidth(64),
                margin: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(12),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      HelperMethods().getMyDynamicHeight(16),
                    ),
                    color: selectedIndex == 1
                        ? ColorsConfig().kPrimaryColor
                        : Colors.white),
                child: Icon(
                  Icons.filter_frames_outlined,
                  color: selectedIndex == 1
                      ? Colors.white
                      : const Color(0xFF5F5F5F),
                ),
              ),
              label: 'Orders'),
          BottomNavigationBarItem(
              icon: Container(
                height: HelperMethods().getMyDynamicHeight(32),
                width: HelperMethods().getMyDynamicWidth(64),
                margin: EdgeInsets.only(
                  top: HelperMethods().getMyDynamicHeight(12),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      HelperMethods().getMyDynamicHeight(16),
                    ),
                    color: selectedIndex == 2
                        ? ColorsConfig().kPrimaryColor
                        : Colors.white),
                child: Icon(
                  Icons.account_circle_outlined,
                  color: selectedIndex == 2
                      ? Colors.white
                      : const Color(0xFF5F5F5F),
                ),
              ),
              label: 'Profile'),
        ],
      ),
    );
  }
}
