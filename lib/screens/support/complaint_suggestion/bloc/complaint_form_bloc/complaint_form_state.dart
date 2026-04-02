part of 'complaint_form_bloc.dart';

sealed class ComplaintFormState extends Equatable{
  const ComplaintFormState();
}

final class ComplaintFormInitial extends ComplaintFormState {
  const ComplaintFormInitial();

  @override
  List<Object?> get props => [];
}
final class ComplaintFormLoading extends ComplaintFormState {
  const ComplaintFormLoading();
  @override
  List<Object?> get props => [];
}
final class ComplaintFormError extends ComplaintFormState {
  final String? errorMessage;
  const ComplaintFormError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];

}
