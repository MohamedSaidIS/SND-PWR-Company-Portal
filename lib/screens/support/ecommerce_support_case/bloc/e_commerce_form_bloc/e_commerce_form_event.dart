part of 'e_commerce_form_bloc.dart';

sealed class EcommerceFormEvent {}

final class CreateEcommerceItemEvent extends EcommerceFormEvent{

  final int userId;
  final String title;
  final String description;
  final String? selectedApp;
  final String? selectedPriority;
  final String? selectedType;
  final List<AttachedBytes> attachedFiles;

  CreateEcommerceItemEvent(
      {required this.userId,
      required this.title,
      required this.description,
      this.selectedApp,
      this.selectedPriority,
      this.selectedType,
      required this.attachedFiles,
      });
}

final class ChangeAppEvent extends EcommerceFormEvent{
  final String? selectApp;
  ChangeAppEvent(this.selectApp);
}

final class ChangePriorityEvent extends EcommerceFormEvent{
  final String? selectedPriority;
  ChangePriorityEvent(this.selectedPriority);
}

final class ChangeTypeEvent extends EcommerceFormEvent{
  final String? selectedType;
  ChangeTypeEvent(this.selectedType);
}
