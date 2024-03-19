part of products_bloc;
// import 'package:equatable/equatable.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsLoading extends ProductsState {
  // loader here
}

class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;

  const ProductsLoaded({
    this.products = const <ProductModel>[],
  }); // bring products here

  @override
  List<Object> get props => [products];
}

class ProductsEmptyState extends ProductsState {}

class NoInternetState extends ProductsState {}
