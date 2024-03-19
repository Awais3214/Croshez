part of 'store_details_bloc_bloc.dart';

abstract class StoreDetailsBlocEvent extends Equatable {
  const StoreDetailsBlocEvent();

  @override
  List<Object> get props => [];
}

class StoreDetailsLoadedEvent extends StoreDetailsBlocEvent {
  final StoreModel? storeDetails;

  const StoreDetailsLoadedEvent({
    this.storeDetails,
  });
}

class StoreDetailsEmptyEvent extends StoreDetailsBlocEvent {}
