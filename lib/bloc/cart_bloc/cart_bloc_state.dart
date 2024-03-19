part of 'cart_bloc_bloc.dart';

@immutable
abstract class CartBlocState {}

class CartBlocLoading extends CartBlocState {}

class CartBlocLoaded extends CartBlocState {
  final List<CartModel> carModelList;

  CartBlocLoaded(this.carModelList);
}

class CartBlocEmpty extends CartBlocState {}
