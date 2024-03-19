part of 'seller_home_page_bloc.dart';

abstract class SellerHomePageState extends Equatable {
  const SellerHomePageState();

  @override
  List<Object> get props => [];
}

class StoreLoading extends SellerHomePageState {}

class StoreProductsLoaded extends SellerHomePageState {
  final List<ProductModel>? products;

  const StoreProductsLoaded({
    this.products,
  });
}

class StoreProductsEmptyState extends SellerHomePageState {}

class NoInternetState extends SellerHomePageState {}
