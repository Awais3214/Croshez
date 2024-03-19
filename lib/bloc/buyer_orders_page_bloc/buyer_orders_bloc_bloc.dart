import 'package:bloc/bloc.dart';
import 'package:croshez/models/order_model.dart';
import 'package:equatable/equatable.dart';

part 'buyer_orders_bloc_event.dart';
part 'buyer_orders_bloc_state.dart';

class BuyerOrdersBlocBloc
    extends Bloc<BuyerOrdersBlocEvent, BuyerOrdersBlocState> {
  BuyerOrdersBlocBloc() : super(LoadingOrderState()) {
    on<OrdersLoadedEvent>(onLoadOrders);
  }

  void onLoadOrders(
      OrdersLoadedEvent event, Emitter<BuyerOrdersBlocState> emit) {
    emit(
      LoadedOrderState(orderModelList: event.orderModelList),
    );
  }

  void onEmptyOrders(
      OrdersEmptyEvent event, Emitter<BuyerOrdersBlocState> emit) {
    emit(EmptyOrdersState());
  }
}
