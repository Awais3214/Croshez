part of 'seller_orders_page_bloc.dart';

abstract class SellerOrdersPageEvent extends Equatable {
  const SellerOrdersPageEvent();

  @override
  List<Object> get props => [];
}

class SellerOrdersLoadedEvent extends SellerOrdersPageEvent {
  final List<OrderModel> orders;

  const SellerOrdersLoadedEvent({required this.orders});
}

class SellerOrdersEmptyEvent extends SellerOrdersPageEvent {}

class SellerOrdersLoadingEvent extends SellerOrdersPageEvent {}
