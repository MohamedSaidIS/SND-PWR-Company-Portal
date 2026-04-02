part of 'e_commerce_form_bloc.dart';

sealed class ECommerceFormEvent {}

final class CreateECommerceItemEvent extends ECommerceFormEvent{

  final int userId;
  final String title;
  final String description;
  final String? selectedApp;
  final String? selectedPriority;
  final String? selectedType;
  final List<AttachedBytes> attachedFiles;

  CreateECommerceItemEvent(
      {required this.userId,
      required this.title,
      required this.description,
      this.selectedApp,
      this.selectedPriority,
      this.selectedType,
      required this.attachedFiles,
      });
}
