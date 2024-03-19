library products_bloc;

import 'package:bloc/bloc.dart';
import 'package:croshez/models/product_model.dart';
import 'package:equatable/equatable.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsLoading()) {
    on<LoadProducts>(_onLoadProducts);
    on<UpdateProducts>(_onUpdateProducts);
    on<AddProducts>(_onAddProducts);
    on<DeleteProducts>(_onDeleteProducts);
    on<ProductsEmptyEvent>(_onProductsEmpty);
    on<NoInternetEvent>(onNoInternetEvent);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductsState> emit) {
    emit(
      ProductsLoaded(products: event.products),
    );
  }

  void _onProductsEmpty(ProductsEmptyEvent event, Emitter<ProductsState> emit) {
    emit(ProductsEmptyState());
  }

  void _onUpdateProducts(UpdateProducts event, Emitter<ProductsState> emit) {}
  void _onAddProducts(AddProducts event, Emitter<ProductsState> emit) {}
  void _onDeleteProducts(DeleteProducts event, Emitter<ProductsState> emit) {}

  void onNoInternetEvent(NoInternetEvent event, Emitter<ProductsState> emit) {
    emit(NoInternetState());
  }
}
