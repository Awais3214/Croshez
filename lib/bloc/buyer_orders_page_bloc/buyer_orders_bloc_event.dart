part of 'buyer_orders_bloc_bloc.dart';

abstract class BuyerOrdersBlocEvent extends Equatable {
  const BuyerOrdersBlocEvent();

  @override
  List<Object> get props => [];
}

class OrdersLoadingEvent extends BuyerOrdersBlocEvent {}

class OrdersLoadedEvent extends BuyerOrdersBlocEvent {
  final List<OrderModel> orderModelList;

  const OrdersLoadedEvent(this.orderModelList);
}

class OrdersEmptyEvent extends BuyerOrdersBlocEvent {}
