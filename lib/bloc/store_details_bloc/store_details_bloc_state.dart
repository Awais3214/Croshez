part of 'store_details_bloc_bloc.dart';

abstract class StoreDetailsBlocState extends Equatable {
  const StoreDetailsBlocState();

  @override
  List<Object> get props => [];
}

class StoreDetailsLoading extends StoreDetailsBlocState {}

class StoreDetailsLoaded extends StoreDetailsBlocState {
  final StoreModel? storeDetails;

  const StoreDetailsLoaded({
    this.storeDetails,
  });
}

class StoreDetailsEmpty extends StoreDetailsBlocState {}
