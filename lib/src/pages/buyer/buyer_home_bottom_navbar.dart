import 'package:croshez/bloc/buyer_orders_page_bloc/buyer_orders_bloc_bloc.dart';
import 'package:croshez/bloc/cart_bloc/cart_bloc_bloc.dart';
import 'package:croshez/bloc/user_details_bloc/user_bloc_bloc.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/helper/common_methods.dart';
import 'package:croshez/src/pages/buyer/buyer_homescreen.dart';
import 'package:croshez/src/pages/buyer/buyer_profile_page.dart';
import 'package:croshez/src/pages/buyer/cart.dart';
import 'package:croshez/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/buyer_services.dart';
import '../../../utils/my_shared_preferecnces.dart';

class BuyerPageBottomNavBar extends StatefulWidget {
  final int selectedIndex;

  const BuyerPageBottomNavBar({
    Key? key,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  State<BuyerPageBottomNavBar> createState() => _BuyerPageBottomNavBarState();
}

class _BuyerPageBottomNavBarState extends State<BuyerPageBottomNavBar> {
  late int selectedIndex;

  @override
  void initState() {
    Conn().connectivityResult().then((value) {
      if (value) {
        BuyerServices().getAllProducts(context);
        BuyerServices().getOrderData(context);
        BuyerServices().getCartData(context);
        BuyerServices().getUserDetails(context);
        BuyerServices().getAddressInfo(context);
      } else {
        context.read<UserBlocBloc>().add(UserEmptyEvent());
        context.read<CartBlocBloc>().add(CartEmptyEvent());
        context.read<BuyerOrdersBlocBloc>().add(OrdersEmptyEvent());
      }
    });
    super.initState();
    selectedIndex = widget.selectedIndex;
    MySharedPreferecne().saveUserType('Buyer');
  }

  static final List<Widget> widgetOptions = <Widget>[
    const BuyerHome(),
    const Cart(),
    const BuyerProfilePage(),
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
                  Icons.shopping_cart_outlined,
                  color: selectedIndex == 1
                      ? Colors.white
                      : const Color(0xFF5F5F5F),
                ),
              ),
              label: 'Cart'),
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
