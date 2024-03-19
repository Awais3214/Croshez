import 'package:bloc/bloc.dart';
import 'package:croshez/models/order_model.dart';
import 'package:equatable/equatable.dart';

part 'seller_orders_page_event.dart';
part 'seller_orders_page_state.dart';

class SellerOrdersPageBloc
    extends Bloc<SellerOrdersPageEvent, SellerOrdersPageState> {
  SellerOrdersPageBloc() : super(SellerOrdersLoading()) {
    on<SellerOrdersLoadedEvent>((event, emit) {
      emit(SellerOrdersLoading());
      emit(SellerOrdersLoaded(orders: event.orders));
    });
    on<SellerOrdersEmptyEvent>(
      (event, emit) {
        emit(SellerOrdersEmpty());
      },
    );
    on<SellerOrdersLoadingEvent>(
      (event, emit) {
        emit(SellerOrdersLoading());
      },
    );
  }
}
