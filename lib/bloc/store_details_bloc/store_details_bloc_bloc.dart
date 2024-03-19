import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/store_model.dart';

part 'store_details_bloc_event.dart';
part 'store_details_bloc_state.dart';

class StoreDetailsBlocBloc
    extends Bloc<StoreDetailsBlocEvent, StoreDetailsBlocState> {
  StoreDetailsBlocBloc() : super(StoreDetailsLoading()) {
    on<StoreDetailsLoadedEvent>(
      (event, emit) {
        emit(StoreDetailsLoaded(storeDetails: event.storeDetails));
      },
    );
    on<StoreDetailsEmptyEvent>(
      (event, emit) {
        emit(StoreDetailsEmpty());
      },
    );
  }
}
