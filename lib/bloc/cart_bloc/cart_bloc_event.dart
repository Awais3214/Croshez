part of 'cart_bloc_bloc.dart';

@immutable
abstract class CartBlocEvent {}

class CartLoadingEvent extends CartBlocEvent {}

class CartLoadedEvent extends CartBlocEvent {
  final List<CartModel> cartModelList;
  CartLoadedEvent(this.cartModelList);
}

class CartEmptyEvent extends CartBlocEvent {}
