import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';
part 'seller_home_page_event.dart';
part 'seller_home_page_state.dart';

class SellerHomePageBloc
    extends Bloc<SellerHomePageEvent, SellerHomePageState> {
  SellerHomePageBloc() : super(StoreLoading()) {
    on<StoreProductsLoadedEvent>(_onLoadProducts);
    on<StoreProductsEmptyEvent>(
      (event, emit) {
        emit(StoreProductsEmptyState());
      },
    );
    on<NoInternetEvent>(_onNoInternetState);
  }

  void _onLoadProducts(event, emit) {
    emit(
      StoreProductsLoaded(
        products: event.products,
      ),
    );
  }

  void _onNoInternetState(event, emit) {
    emit(
      NoInternetState(),
    );
  }
}
