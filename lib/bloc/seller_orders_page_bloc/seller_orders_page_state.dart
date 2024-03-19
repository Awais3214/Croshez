part of 'seller_orders_page_bloc.dart';

abstract class SellerOrdersPageState extends Equatable {
  const SellerOrdersPageState();

  @override
  List<Object> get props => [];
}

class SellerOrdersLoading extends SellerOrdersPageState {}

class SellerOrdersLoaded extends SellerOrdersPageState {
  final List<OrderModel> orders;

  const SellerOrdersLoaded({required this.orders});
}

class SellerOrdersEmpty extends SellerOrdersPageState {}
