part of 'user_bloc_bloc.dart';

abstract class UserBlocState extends Equatable {
  const UserBlocState();

  @override
  List<Object> get props => [];
}

class LoadingUserDetails extends UserBlocState {}

class LoadedUserDetails extends UserBlocState {
  final UserModel? userDetails;

  const LoadedUserDetails({this.userDetails});
}

class EmptyUserDetails extends UserBlocState {}
