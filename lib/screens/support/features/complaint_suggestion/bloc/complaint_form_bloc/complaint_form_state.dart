part of 'complaint_form_bloc.dart';

class ComplaintFormState {
  final String selectedType;
  final bool isChecked;
  final FormStatus status;
  final String? errorMessage;
  final String? selectedCategory;
  final String? selectedPriority;

  const ComplaintFormState({
    this.selectedType = "Complaint",
    this.isChecked = true,
    this.status = FormStatus.loading,
    this.errorMessage,
    this.selectedCategory,
    this.selectedPriority = 'Normal'
  });

  ComplaintFormState copyWith({
    String? selectedType,
    bool? isChecked,
    FormStatus? status,
    String? errorMessage,
    String? selectedCategory,
    String? selectedPriority,
  }) {
    return ComplaintFormState(
      selectedType: selectedType ?? this.selectedType,
      isChecked: isChecked ?? this.isChecked,
      status: status ?? this.status,
      errorMessage: errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedPriority: selectedPriority ?? this.selectedPriority
    );
  }
}