part of 'profile_bloc.dart';

class ProfileState {
  final bool isLoading;
  final String? errorMessage;
  final UserInfo? managerInfo;
  final List<DirectReport> reportItems;

  ProfileState({
    this.isLoading = false,
    this.errorMessage,
    this.managerInfo,
    this.reportItems = const [],
});

  ProfileState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserInfo? managerInfo,
    List<DirectReport>? reportItems,
}){
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      managerInfo: managerInfo ?? this.managerInfo,
      reportItems: reportItems ?? this.reportItems,
    );
}
}
