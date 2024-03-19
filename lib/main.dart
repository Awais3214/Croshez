import 'package:croshez/bloc/address_bloc/address_bloc.dart';
import 'package:croshez/bloc/buyer_orders_page_bloc/buyer_orders_bloc_bloc.dart';
import 'package:croshez/bloc/seller_home_page_bloc/seller_home_page_bloc.dart';
import 'package:croshez/bloc/seller_orders_page_bloc/seller_orders_page_bloc.dart';
import 'package:croshez/bloc/store_details_bloc/store_details_bloc_bloc.dart';
import 'package:croshez/bloc/user_details_bloc/user_bloc_bloc.dart';
import 'package:croshez/root_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'admin/dashboard/bloc/dashboard_stats_bloc.dart';
import 'bloc/buyer_home_page_bloc/products_bloc.dart';
import 'bloc/cart_bloc/cart_bloc_bloc.dart';
import 'firebase_options.dart';
// import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // double height = 844;
    // double width = 390;
    // SizeConfig().init(context, height, width);
    // SizeConfig().init(context, MediaQuery.of(context).size.height,
    //     MediaQuery.of(context).size.width);
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressBloc>(
          create: (context) => AddressBloc(),
        ),
        BlocProvider<BuyerOrdersBlocBloc>(
          create: (context) => BuyerOrdersBlocBloc(),
        ),
        BlocProvider<CartBlocBloc>(
          create: (context) => CartBlocBloc(),
        ),
        BlocProvider<ProductsBloc>(
          create: (context) => ProductsBloc(),
        ),
        BlocProvider<DashboardStatsBloc>(
          create: (context) => DashboardStatsBloc(),
        ),
        BlocProvider<SellerHomePageBloc>(
          create: (context) => SellerHomePageBloc(),
        ),
        BlocProvider<UserBlocBloc>(
          create: (context) => UserBlocBloc(),
        ),
        BlocProvider<StoreDetailsBlocBloc>(
          create: (context) => StoreDetailsBlocBloc(),
        ),
        BlocProvider<SellerOrdersPageBloc>(
          create: (context) => SellerOrdersPageBloc(),
        )
      ],
      child: GetMaterialApp(
        title: 'Croshez',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.grey,
          scaffoldBackgroundColor: Colors.white,
        ),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => const RootPage(),
        },
      ),
    );
  }
}
