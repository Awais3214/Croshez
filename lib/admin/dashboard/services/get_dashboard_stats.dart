import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardStatusEndpoint {
  Future<Map<String, Map<String, dynamic>>> getstatus() async {
    // final shops = await FirebaseFirestore.instance.collection('shop');
    QuerySnapshot shopQuerySnapshot =
        await FirebaseFirestore.instance.collection('shop').get();
    final shopList = shopQuerySnapshot.docs.map((doc) => doc.data()).toList();
    QuerySnapshot usersQuerySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    final usersList = usersQuerySnapshot.docs.map((doc) => doc.data()).toList();
    QuerySnapshot productsQuerySnapshot =
        await FirebaseFirestore.instance.collection('product').get();
    final productList =
        productsQuerySnapshot.docs.map((doc) => doc.data()).toList();

    QuerySnapshot ordersQuerySnapshot =
        await FirebaseFirestore.instance.collection('orders').get();
    final ordersList =
        ordersQuerySnapshot.docs.map((doc) => doc.data()).toList();

    Map<String, Map<String, dynamic>> dashboardStats = {
      "shops": {
        "total": shopList.length,
        "data": shopList,
      },
      "customers": {
        "total": usersList.length,
        "data": usersList,
      },
      "products": {
        "total": productList.length,
        "data": productList,
      },
      "orders": {
        "total": ordersList.length,
        "data": ordersList,
      },
    };
    // print(shopList);
    // print(usersList);
    // print(productList);
    return dashboardStats;
    // FirebaseFirestore.instance.collection(products);
  }
}
