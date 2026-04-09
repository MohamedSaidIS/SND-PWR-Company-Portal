part of 'dynamics_form_bloc.dart';


class DynamicsFormState{
  final FormStatus status;
  final String? errorMessage;
  final String? selectedPurpose;
  final String? selectedPriority;

  DynamicsFormState({
      this.status = FormStatus.initial,
      this.errorMessage,
      this.selectedPurpose,
      this.selectedPriority = 'Normal'});

  DynamicsFormState copyWith({
    FormStatus? status,
    String? errorMessage,
    String? selectedPurpose,
    String? selectedPriority,
}){
    return DynamicsFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      selectedPurpose: selectedPurpose ?? this.selectedPurpose,
      selectedPriority: selectedPriority ?? this.selectedPriority
    );
  }
}