part of 'e_commerce_bloc.dart';

sealed class ECommerceEvent {}

final class GetECommerceItemsEvent extends ECommerceEvent{
  final int userId;
  GetECommerceItemsEvent(this.userId);
}

