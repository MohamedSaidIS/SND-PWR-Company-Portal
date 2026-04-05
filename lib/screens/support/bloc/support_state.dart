part of 'support_bloc.dart';

class SupportState {
  final Map<int, bool> animatedCards;
  final bool isLoading;
  final String? errorMessage;
  final EnsureUser? itUser;
  final EnsureUser? alsanidiUser;
  final EnsureUser? dynamicsUser;

  SupportState({this.animatedCards = const {}, this.isLoading = false, this.errorMessage, this.itUser, this.alsanidiUser, this.dynamicsUser});

  SupportState copyWith({
    Map<int, bool>? animatedCards,
    bool? isLoading,
    String? errorMessage,
    EnsureUser? itUser,
    EnsureUser? alsanidiUser,
    EnsureUser? dynamicsUser,
}){
    return SupportState(
      animatedCards: animatedCards ?? this.animatedCards,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      itUser: itUser ?? this.itUser,
      alsanidiUser: alsanidiUser ?? this.alsanidiUser,
      dynamicsUser: dynamicsUser ?? this.dynamicsUser,
    );
  }

}
