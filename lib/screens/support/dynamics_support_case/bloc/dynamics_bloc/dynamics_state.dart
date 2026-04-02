part of 'dynamics_bloc.dart';

sealed class DynamicsState extends Equatable{
  const DynamicsState();

  @override
  List<Object?> get props => [];
}

final class DynamicsLoading  extends DynamicsState {
  const DynamicsLoading();
  @override
  List<Object?> get props => [];
}
final class DynamicsLoaded  extends DynamicsState {
  final List<DynamicsItem> dynamicsList;
  const DynamicsLoaded(this.dynamicsList);

  @override
  List<Object?> get props => [dynamicsList];
}
final class DynamicsEmpty  extends DynamicsState {
  const DynamicsEmpty();

  @override
  List<Object?> get props => [];
}
final class DynamicsError  extends DynamicsState {
  final String? errorMessage;
  const DynamicsError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
