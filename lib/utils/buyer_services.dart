import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/bloc/user_details_bloc/user_bloc_bloc.dart';
import 'package:croshez/helper/check_connectivity.dart';
import 'package:croshez/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/address_bloc/address_bloc.dart';
import '../bloc/buyer_home_page_bloc/products_bloc.dart';
import '../bloc/buyer_orders_page_bloc/buyer_orders_bloc_bloc.dart';
import '../bloc/cart_bloc/cart_bloc_bloc.dart';
import '../models/address_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

class BuyerServices {
  Future<UserModel> getUserDetails(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    CollectionReference collection =
        FirebaseFirestore.instance.collection('users');
    var list =
        await collection.where(FieldPath.documentId, isEqualTo: user.uid).get();
    try {
      UserModel gUserDetails = list.docs
          .map(
            (doc) => UserModel.fromMap(
              doc.data(),
            ),
          )
          .toList()
          .first;
      if (context.mounted) {
        context
            .read<UserBlocBloc>()
            .add(UserLoadedEvent(userDetails: gUserDetails));
      }
      return gUserDetails;
    } catch (e) {
      var snackBar = SnackBar(content: Text(e.toString()));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      return UserModel();
    }
  }

  void getAddressInfo(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    CollectionReference collection =
        FirebaseFirestore.instance.collection('address');
    var list = await collection.where("userId", isEqualTo: user.uid).get();
    List<AddressModel> addressDetails = list.docs
        .map(
          (doc) => AddressModel.fromMap(
            doc.data(),
          ),
        )
        .toList();
    if (context.mounted) {
      context.read<AddressBloc>().add(
            AddressLoadedEvent(addressDetails),
          );
    }
  }

  Future<void> getOrderData(BuildContext context) async {
    CollectionReference orderCollection =
        FirebaseFirestore.instance.collection('orders');
    QuerySnapshot ordersListDB = await orderCollection
        .where("buyerId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<OrderModel> orders = ordersListDB.docs
        .map((e) => OrderModel.fromMap(
              e.data(),
            ))
        .toList();

    orders.sort(
      (a, b) => b.orderId!.compareTo(a.orderId!),
    );
    if (context.mounted) {
      context.read<BuyerOrdersBlocBloc>().add(OrdersLoadedEvent(orders));
    }
  }

  static updatefavorite(updateHeart, productID) async {
    await FirebaseFirestore.instance
        .collection('product')
        .doc(productID)
        .update({
      'favorite': updateHeart,
    });
  }

  Future<String> getShopName(shopId) async {
    DocumentSnapshot shopSnapshot =
        await FirebaseFirestore.instance.collection('shop').doc(shopId).get();
    if (shopSnapshot.exists) {
      String shopName = shopSnapshot.get('shopName');
      return shopName;
    } else {
      throw Exception('Shop not found in database');
    }
  }

  Future getCartData(BuildContext context) async {
    FirebaseFirestore collection = FirebaseFirestore.instance;
    CollectionReference cartCollection = collection.collection('cart');
    QuerySnapshot cartsList = await cartCollection
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<CartModel> cartProductsList = cartsList.docs
        .map((e) => CartModel.fromMap(
              e.data(),
            ))
        .toList();

    if (cartProductsList.isNotEmpty) {
      if (context.mounted) {
        context.read<CartBlocBloc>().add(CartLoadedEvent(cartProductsList));
      }
    } else {
      if (context.mounted) {
        context.read<CartBlocBloc>().add(CartEmptyEvent());
      }
    }
  }

  Future<List<ProductModel>> getAllProducts(BuildContext context) async {
    bool isConnected = await Conn().connectivityResult();
    final List<ProductModel> products = [];
    if (isConnected) {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('product').get();
      for (var doc in snapshot.docs) {
        final favorite = doc['favorite'] as bool;
        final hookSize = doc['hookSize'] as String;
        final price = doc['price'] as String;
        final productDescription = doc['productDescription'] as String;
        final productImage = doc['productImage'] != null
            ? List<String>.from(doc['productImage'] as List<dynamic>)
            : null;
        final productName = doc['productName'] as String;
        final productID = doc.id;
        final shopId = doc['shopId'] as String;
        final userId = doc['userId'] as String;
        final product = ProductModel(
            favorite: favorite,
            hookSize: hookSize,
            price: price,
            productDescription: productDescription,
            productImage: productImage,
            productName: productName,
            productId: productID,
            shopId: shopId,
            userId: userId);
        products.add(product);
      }

      if (context.mounted) {
        if (products.isEmpty) {
          context.read<ProductsBloc>().add(ProductsEmptyEvent());
        } else {
          context.read<ProductsBloc>().add(LoadProducts(
                products: products,
              ));
        }
      }
      return products;
    } else {
      if (context.mounted) {
        context.read<ProductsBloc>().add(NoInternetEvent());
      }
      return products;
    }
  }
}
