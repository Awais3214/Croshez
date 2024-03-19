part of 'buyer_orders_bloc_bloc.dart';

abstract class BuyerOrdersBlocState extends Equatable {
  const BuyerOrdersBlocState();

  @override
  List<Object> get props => [];
}

class LoadingOrderState extends BuyerOrdersBlocState {}

class LoadedOrderState extends BuyerOrdersBlocState {
  final List<OrderModel> orderModelList;

  const LoadedOrderState({
    this.orderModelList = const <OrderModel>[],
  });

  @override
  List<Object> get props => [orderModelList];
}

class EmptyOrdersState extends BuyerOrdersBlocState {}
