part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class AddressLoadedEvent extends AddressEvent {
  final List<AddressModel> addressDetails;

  const AddressLoadedEvent(this.addressDetails);
}
