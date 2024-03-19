part of 'seller_home_page_bloc.dart';

abstract class SellerHomePageEvent extends Equatable {
  const SellerHomePageEvent();

  @override
  List<Object> get props => [];
}

class StoreProductsLoadedEvent extends SellerHomePageEvent {
  final List<ProductModel>? products;

  const StoreProductsLoadedEvent({this.products});
}

class StoreProductsEmptyEvent extends SellerHomePageEvent {}

class NoInternetEvent extends SellerHomePageEvent {}
