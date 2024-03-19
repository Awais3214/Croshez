part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoadedState extends AddressState {
  final List<AddressModel> addressDetails;

  const AddressLoadedState({required this.addressDetails});

  @override
  List<Object> get props => [addressDetails];
}
