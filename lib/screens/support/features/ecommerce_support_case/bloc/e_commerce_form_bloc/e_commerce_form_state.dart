part of 'e_commerce_form_bloc.dart';

class EcommerceFormState{
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? selectedApp;
  final String? selectedPriority;
  final String? selectedType;

  EcommerceFormState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.selectedApp,
    this.selectedPriority  = "Normal",
    this.selectedType});

  EcommerceFormState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? selectedApp,
    String? selectedPriority,
    String? selectedType,
}){
    return EcommerceFormState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedApp: selectedApp ?? this.selectedApp,
      selectedType: selectedType ?? this.selectedType,
      selectedPriority: selectedPriority ?? this.selectedPriority
    );
}

}

// sealed class ECommerceFormState extends Equatable{
//   const ECommerceFormState();
// }
// final class ECommerceFormInitial extends ECommerceFormState {
//   const ECommerceFormInitial();
//
//   @override
//   List<Object?> get props => [];
// }
//
// final class ECommerceFormLoading extends ECommerceFormState {
//   const ECommerceFormLoading();
//
//   @override
//   List<Object?> get props => [];
// }
// final class ECommerceFormSuccess extends ECommerceFormState {
//   const ECommerceFormSuccess();
//
//   @override
//   List<Object?> get props => [];
// }
// final class ECommerceFormError extends ECommerceFormState {
//   final String? errorMessage;
//   const ECommerceFormError(this.errorMessage);
//   @override
//   List<Object?> get props => [errorMessage];
// }
