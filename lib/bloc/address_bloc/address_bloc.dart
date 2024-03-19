import 'package:bloc/bloc.dart';
import 'package:croshez/models/address_model.dart';
import 'package:equatable/equatable.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressInitial()) {
    on<AddressLoadedEvent>((event, emit) {
      emit(
        AddressLoadedState(addressDetails: event.addressDetails),
      );
    });
  }
}
