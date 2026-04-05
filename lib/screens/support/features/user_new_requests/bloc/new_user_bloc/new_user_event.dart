part of 'new_user_bloc.dart';

sealed class NewUserEvent {}

final class GetNewUserItemsEvent extends NewUserEvent{
  final int userId;
  GetNewUserItemsEvent(this.userId);
}
