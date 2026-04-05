part of 'dynamics_form_bloc.dart';

sealed class DynamicsFormEvent {}

final class CreateDynamicsItemEvent extends DynamicsFormEvent{

  final int userId;
  final String? title;
  final String? description;
  final String selectedPriority;
  final String selectedArea;
  final String selectedPurpose;
  final String dateReported;
  final List<AttachedBytes> attachedFiles;

  CreateDynamicsItemEvent(
      {required this.userId,
        required this.title,
        required this.description,
        required this.selectedPriority,
        required this.selectedArea,
        required this.selectedPurpose,
        required this.dateReported,
        required this.attachedFiles,
      });


}

final class ChangeDynamicsPriorityEvent extends DynamicsFormEvent{
  final String? selectedPriority;

  ChangeDynamicsPriorityEvent(this.selectedPriority);
}

final class ChangeDynamicsPurposeEvent extends DynamicsFormEvent{
  final String? selectedPurpose;

  ChangeDynamicsPurposeEvent(this.selectedPurpose);
}

