part of 'user_bloc_bloc.dart';

abstract class UserBlocEvent extends Equatable {
  const UserBlocEvent();

  @override
  List<Object> get props => [];
}

class UserLoadedEvent extends UserBlocEvent {
  final UserModel? userDetails;

  const UserLoadedEvent({this.userDetails});
}

class UserEmptyEvent extends UserBlocEvent {}
