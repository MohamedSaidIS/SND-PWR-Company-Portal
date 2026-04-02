part of 'e_commerce_form_bloc.dart';

sealed class ECommerceFormState extends Equatable{
  const ECommerceFormState();
}
final class ECommerceFormInitial extends ECommerceFormState {
  const ECommerceFormInitial();

  @override
  List<Object?> get props => [];
}

final class ECommerceFormLoading extends ECommerceFormState {
  const ECommerceFormLoading();

  @override
  List<Object?> get props => [];
}
final class ECommerceFormSuccess extends ECommerceFormState {
  const ECommerceFormSuccess();

  @override
  List<Object?> get props => [];
}
final class ECommerceFormError extends ECommerceFormState {
  final String? errorMessage;
  const ECommerceFormError(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
