part of 'dynamics_form_bloc.dart';


class DynamicsFormState{
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? selectedPurpose;
  final String? selectedPriority;

  DynamicsFormState(
      {this.isLoading = false,
      this.isSuccess = false,
      this.errorMessage,
      this.selectedPurpose,
      this.selectedPriority = 'Normal'});

  DynamicsFormState copyWith({
    final bool? isLoading,
    final bool? isSuccess,
    final String? errorMessage,
    final String? selectedPurpose,
    final String? selectedPriority,
}){
    return DynamicsFormState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedPurpose: selectedPurpose ?? this.selectedPurpose,
      selectedPriority: selectedPriority ?? this.selectedPriority
    );
  }
}
// sealed class DynamicsFormState extends Equatable{
//   const DynamicsFormState();
// }
//
// final class DynamicsFormInitial extends DynamicsFormState {
//   const DynamicsFormInitial();
//
//   @override
//   List<Object?> get props => [];
//
// }
// final class DynamicsFormLoading extends DynamicsFormState {
//   const DynamicsFormLoading();
//
//   @override
//   List<Object?> get props => [];
//
// }
// final class DynamicsFormSuccess extends DynamicsFormState {
//   const DynamicsFormSuccess();
//
//   @override
//   List<Object?> get props => [];
//
// }
// final class DynamicsFormError extends DynamicsFormState {
//   final String? errorMessage;
//   const DynamicsFormError(this.errorMessage);
//
//   @override
//   List<Object?> get props => [errorMessage];
//
// }

