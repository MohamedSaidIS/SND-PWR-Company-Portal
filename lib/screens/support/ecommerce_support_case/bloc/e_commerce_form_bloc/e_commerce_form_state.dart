part of 'e_commerce_form_bloc.dart';

sealed class ECommerceFormState extends Equatable{}
final class ECommerceFormInitial extends ECommerceFormState {
  @override
  List<Object?> get props => [];
}

final class ECommerceFormLoading extends ECommerceFormState {
  @override
  List<Object?> get props => [];
}
final class ECommerceFormSuccess extends ECommerceFormState {
  @override
  List<Object?> get props => [];
}
final class ECommerceFormError extends ECommerceFormState {
  final String? errorMessage;
  ECommerceFormError(this.errorMessage);
  @override
  List<Object?> get props => [];
}
