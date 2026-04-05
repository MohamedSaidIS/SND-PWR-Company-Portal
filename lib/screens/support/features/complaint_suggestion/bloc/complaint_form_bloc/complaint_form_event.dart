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

final class ChangeComplaintTypeEvent extends ComplaintFormEvent{
  final String type;
  ChangeComplaintTypeEvent(this.type);
}

final class ToggleEvent extends ComplaintFormEvent{
  final bool isChecked;
  ToggleEvent(this.isChecked);
}

final class ChangeComplaintCategoryEvent extends ComplaintFormEvent{
  final String category;
  ChangeComplaintCategoryEvent(this.category);
}

class ChangeComplaintPriorityEvent extends ComplaintFormEvent{
  final String priority;
  ChangeComplaintPriorityEvent(this.priority);
}