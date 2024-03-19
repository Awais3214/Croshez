import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../models/cart_model.dart';
part 'cart_bloc_event.dart';
part 'cart_bloc_state.dart';

class CartBlocBloc extends Bloc<CartBlocEvent, CartBlocState> {
  CartBlocBloc() : super(CartBlocLoading()) {
    on<CartLoadingEvent>((event, emit) {});

    on<CartLoadedEvent>((event, emit) {
      emit(CartBlocLoaded(event.cartModelList));
    });

    on<CartEmptyEvent>(
      (event, emit) {
        emit(CartBlocEmpty());
      },
    );
  }
}
