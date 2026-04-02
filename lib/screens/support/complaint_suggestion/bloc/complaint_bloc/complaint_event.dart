part of 'complaint_bloc.dart';


sealed class ComplaintEvent {}

final class GetComplaintItemsEvent extends ComplaintEvent{
  final int userId;
  GetComplaintItemsEvent(this.userId);
}
