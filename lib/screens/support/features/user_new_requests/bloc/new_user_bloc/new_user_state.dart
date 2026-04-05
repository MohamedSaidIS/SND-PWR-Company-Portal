part of 'new_user_bloc.dart';

sealed class NewUserState extends Equatable{
  const NewUserState();

  @override
  List<Object?> get props => [];
}

final class NewUserLoading extends NewUserState {
  const NewUserLoading();

  @override
  List<Object?> get props => [];
}

final class NewUserLoaded extends NewUserState {
  final List<NewUserItem> newUserItems;
  const NewUserLoaded(this.newUserItems);

  @override
  List<Object?> get props => [newUserItems];
}

final class NewUserError extends NewUserState {
  final String? errorMessage;
  const NewUserError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

final class NewUserEmpty extends NewUserState {
  const NewUserEmpty();

  @override
  List<Object?> get props => [];
}
