part of 'dynamics_form_bloc.dart';


sealed class DynamicsFormState extends Equatable{
  const DynamicsFormState();
}

final class DynamicsFormInitial extends DynamicsFormState {
  const DynamicsFormInitial();

  @override
  List<Object?> get props => [];

}
final class DynamicsFormLoading extends DynamicsFormState {
  const DynamicsFormLoading();

  @override
  List<Object?> get props => [];

}
final class DynamicsFormSuccess extends DynamicsFormState {
  const DynamicsFormSuccess();

  @override
  List<Object?> get props => [];

}
final class DynamicsFormError extends DynamicsFormState {
  final String? errorMessage;
  const DynamicsFormError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];

}

