part of 'e_commerce_form_bloc.dart';

class EcommerceFormState{
  final FormStatus status;
  final String? errorMessage;
  final String? selectedApp;
  final String? selectedPriority;
  final String? selectedType;

  EcommerceFormState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.selectedApp,
    this.selectedPriority  = "Normal",
    this.selectedType});

  EcommerceFormState copyWith({
    FormStatus? status,
    String? errorMessage,
    String? selectedApp,
    String? selectedPriority,
    String? selectedType,
  }){
    return EcommerceFormState(
     status: status ?? this.status,
      errorMessage: errorMessage,
      selectedApp: selectedApp ?? this.selectedApp,
      selectedType: selectedType ?? this.selectedType,
      selectedPriority: selectedPriority ?? this.selectedPriority
    );
  }

}