import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/user_model.dart';

part 'user_bloc_event.dart';
part 'user_bloc_state.dart';

class UserBlocBloc extends Bloc<UserBlocEvent, UserBlocState> {
  UserBlocBloc() : super(LoadingUserDetails()) {
    on<UserLoadedEvent>(onLoadUser);
    on<UserEmptyEvent>(onEmptyUser);
  }

  void onLoadUser(UserLoadedEvent event, Emitter<UserBlocState> emit) {
    emit(LoadedUserDetails(userDetails: event.userDetails));
  }

  void onEmptyUser(UserEmptyEvent event, Emitter<UserBlocState> emit) {
    emit(EmptyUserDetails());
  }
}
