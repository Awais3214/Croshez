part of products_bloc;

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductsEvent {
  final List<ProductModel> products;

  const LoadProducts({this.products = const <ProductModel>[]});

  @override
  List<Object> get props => [products];
}

class AddProducts extends ProductsEvent {
  final ProductModel product;

  const AddProducts({required this.product});

  @override
  List<Object> get props => [product];
}

class UpdateProducts extends ProductsEvent {
  final ProductModel product;

  const UpdateProducts({required this.product});

  @override
  List<Object> get props => [product];
}

class DeleteProducts extends ProductsEvent {
  final ProductModel product;

  const DeleteProducts({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductsEmptyEvent extends ProductsEvent {}

class NoInternetEvent extends ProductsEvent {}
