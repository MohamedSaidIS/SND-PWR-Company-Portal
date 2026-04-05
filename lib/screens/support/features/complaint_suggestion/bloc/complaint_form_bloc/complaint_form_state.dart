part of 'complaint_form_bloc.dart';

class ComplaintFormState {
  final String selectedType;
  final bool isChecked;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final String? selectedCategory;
  final String? selectedPriority;

  const ComplaintFormState({
    this.selectedType = "Complaint",
    this.isChecked = true,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.selectedCategory,
    this.selectedPriority = 'Normal'
  });

  ComplaintFormState copyWith({
    String? selectedType,
    bool? isChecked,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    String? selectedCategory,
    String? selectedPriority,
  }) {
    return ComplaintFormState(
      selectedType: selectedType ?? this.selectedType,
      isChecked: isChecked ?? this.isChecked,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? false,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedPriority: selectedPriority ?? this.selectedPriority
    );
  }
}

// sealed class ComplaintFormState extends Equatable{
//   const ComplaintFormState();
// }
//
// final class ComplaintFormInitial extends ComplaintFormState {
//   final String selectedType;
//   final bool isChecked;
//
//   const ComplaintFormInitial({
//     this.selectedType ="Complaint",
//     this.isChecked = false,
// });
//
//   ComplaintFormInitial copyWith({
//     String? selectedType,
//     bool? isChecked,
// }){
//     return ComplaintFormInitial(
//       selectedType: selectedType ?? this.selectedType,
//       isChecked: isChecked ?? this.isChecked,
//     );
//   }
//
//   @override
//   List<Object?> get props => [];
// }
// final class ComplaintFormLoading extends ComplaintFormState {
//   const ComplaintFormLoading();
//   @override
//   List<Object?> get props => [];
// }
// final class ComplaintFormSuccess extends ComplaintFormState {
//   const ComplaintFormSuccess();
//
//   @override
//   List<Object?> get props => [];
//
// }
// final class ComplaintFormError extends ComplaintFormState {
//   final String? errorMessage;
//   const ComplaintFormError(this.errorMessage);
//
//   @override
//   List<Object?> get props => [errorMessage];
// }

