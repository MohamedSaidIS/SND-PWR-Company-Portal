part of 'dynamics_bloc.dart';

sealed class DynamicsEvent {}

final class GetDynamicsItemsEvent extends DynamicsEvent{
  final int userId;
  GetDynamicsItemsEvent(this.userId);
}
