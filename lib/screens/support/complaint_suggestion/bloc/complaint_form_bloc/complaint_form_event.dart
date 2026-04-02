part of 'complaint_form_bloc.dart';

sealed class ComplaintFormEvent {}

final class CreateComplaintItemEvent extends ComplaintFormEvent{

  final int userId;
  final String? title;
  final String? description;
  final String? selectedPriority;
  final String? selectedDepartment;
  final String? userName;
  final List<AttachedBytes> attachedFiles;

  CreateComplaintItemEvent(
      {required this.userId,
        required this.title,
        required this.description,
        required this.selectedPriority,
        required this.selectedDepartment,
        required this.userName,
        required this.attachedFiles,
      });


}
