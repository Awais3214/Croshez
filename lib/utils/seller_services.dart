import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/seller_home_page_bloc/seller_home_page_bloc.dart';
import '../bloc/seller_orders_page_bloc/seller_orders_page_bloc.dart';
import '../bloc/store_details_bloc/store_details_bloc_bloc.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';

class SellerServices {
  Future<StoreModel> getStoreDetails(BuildContext context) async {
    bool isConnected = await Conn().connectivityResult();
    if (isConnected) {
      StoreModel storeDetails;
      FirebaseAuth auth = FirebaseAuth.instance;
      User user = auth.currentUser!;
      CollectionReference collection =
          FirebaseFirestore.instance.collection('shop');
      var list = await collection.where("userId", isEqualTo: user.uid).get();
      storeDetails = list.docs
          .map(
            (doc) => StoreModel.fromMap(
              doc.data(),
            ),
          )
          .toList()
          .first;

      storeDetails.storeId = list.docs.first.id;
      if (context.mounted) {
        context
            .read<StoreDetailsBlocBloc>()
            .add(StoreDetailsLoadedEvent(storeDetails: storeDetails));
      }
      return storeDetails;
    } else {
      if (context.mounted) {
        context.read<StoreDetailsBlocBloc>().add(StoreDetailsEmptyEvent());
      }
      return StoreModel();
    }
  }

  Future<void> getProductList(BuildContext context) async {
    bool isConnected = await Conn().connectivityResult();
    if (isConnected) {
      FirebaseAuth auth = FirebaseAuth.instance;
      User user = auth.currentUser!;
      CollectionReference collection =
          FirebaseFirestore.instance.collection('product');
      var list = await collection
          .where("userId", isEqualTo: user.uid)
          .orderBy('productName', descending: false)
          .get();
      List<ProductModel> productsList = list.docs.map(
        (doc) {
          Map jsonData = doc.data() as Map;
          jsonData['productId'] = doc.id;
          return ProductModel.fromMap(
            jsonData,
          );
        },
      ).toList();
      if (productsList.isNotEmpty) {
        if (context.mounted) {
          context.read<SellerHomePageBloc>().add(
                StoreProductsLoadedEvent(products: productsList),
              );
        }
      } else {
        if (context.mounted) {
          context.read<SellerHomePageBloc>().add(
                StoreProductsEmptyEvent(),
              );
        }
      }
    } else {
      if (context.mounted) {
        context.read<SellerHomePageBloc>().add(
              NoInternetEvent(),
            );
      }
    }
  }

  Future<List<OrderModel>> getOrderData(BuildContext context) async {
    StoreModel shopDetails = StoreModel();
    bool isConnected = await Conn().connectivityResult();
    if (context.mounted) {
      if (isConnected) {
        shopDetails = await getStoreDetails(context);
        FirebaseFirestore collection = FirebaseFirestore.instance;
        CollectionReference orderCollection = collection.collection('orders');
        QuerySnapshot ordersListDB = await orderCollection.where("store",
            isEqualTo: {
              'storeId': shopDetails.storeId,
              'storeName': shopDetails.shopName
            }).get();
        List<OrderModel> ordersList = ordersListDB.docs
            .map(
              (e) => OrderModel.fromMap(
                e.data(),
              ),
            )
            .toList();

        ordersList.sort(
          (a, b) => b.orderId!.compareTo(a.orderId!),
        );
        if (context.mounted) {
          context.read<SellerOrdersPageBloc>().add(
                SellerOrdersLoadedEvent(orders: ordersList),
              );
        }
        if (ordersList.isEmpty) {
          if (context.mounted) {
            context.read<SellerOrdersPageBloc>().add(
                  SellerOrdersEmptyEvent(),
                );
          }
        }
        return ordersList;
      } else {
        context.read<SellerOrdersPageBloc>().add(
              SellerOrdersEmptyEvent(),
            );
        return [];
      }
    }
    return [];
  }
}
