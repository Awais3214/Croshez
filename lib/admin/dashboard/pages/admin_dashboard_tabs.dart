import 'package:croshez/helper/common_methods.dart';
import 'package:croshez/src/widgets/custom_margins.dart';
import 'package:croshez/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard_screen.dart';

class AdminDashboardTabs extends StatefulWidget {
  const AdminDashboardTabs({super.key});

  @override
  State<AdminDashboardTabs> createState() => _AdminDashboardTabsState();
}

class _AdminDashboardTabsState extends State<AdminDashboardTabs> {
  List<String> menuOptions = [
    'Dashboard',
    'orders',
    'customers',
    'stores',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FF),
      body: Row(
        children: [
          Container(
            color: Colors.white,
            width: HelperMethods().getMyDynamicWidth(271),
            child: Column(
              children: [
                Container(
                  // width: HelperMethods().getMyDynamicWidth(181),
                  margin: cmargin(
                    top: 40,
                    bottom: 77,
                    left: 44,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: cmargin(
                          right: 18,
                        ),
                        // color: Colors.grey,
                        width: HelperMethods().getMyDynamicWidth(49),
                        height: HelperMethods().getMyDynamicWidth(49),
                        child: Image.asset(
                          'assets/app_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Croshez',
                            style: GoogleFonts.inter(
                              fontSize:
                                  HelperMethods().getMyDynamicFontSize(24),
                            ),
                          ),
                          Text(
                            'Admin Dashboard',
                            style: GoogleFonts.inter(
                              fontSize:
                                  HelperMethods().getMyDynamicFontSize(14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: List.generate(
                      menuOptions.length,
                      (index) => menuTabContainer(
                        menuOptions[index],
                        index == 0,
                        iconData: index == 0
                            ? Icons.home
                            : index == 2
                                ? Icons.people_alt
                                : index == 1
                                    ? Icons.inventory_outlined
                                    : index == 3
                                        ? Icons.store
                                        : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const DashboardScreen(),
        ],
      ),
    );
  }

  Widget menuTabContainer(
    String text,
    bool isSelected, {
    IconData? iconData,
  }) {
    return Container(
      margin: cmargin(
        bottom: 10,
      ),
      padding: cmargin(
        top: 16,
        bottom: 16,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: isSelected ? ColorsConfig().kPrimaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      width: HelperMethods().getMyDynamicWidth(216),
      // height: HelperMethods().getMyDynamicHeight(56),
      child: Row(
        children: [
          Padding(
            padding: cmargin(
              right: 16,
            ),
            child: Icon(
              iconData ?? Icons.whatshot,
              size: HelperMethods().getMyDynamicFontSize(24),
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          Center(
            child: Text(
              text.capitalize ?? '',
              style: GoogleFonts.inter(
                fontSize: HelperMethods().getMyDynamicFontSize(16),
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
