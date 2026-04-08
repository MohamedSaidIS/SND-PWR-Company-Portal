part of 'new_user_form_bloc.dart';

class NewUserFormState {
  final FormStatus status;
  final bool isFilling;
  final String? errorMessage;
  final String? deviceType;
  final String? newEmail;
  final String? useDynamics;
  final String? needPhone;

  NewUserFormState({
    this.status = FormStatus.initial,
    this.isFilling = false,
    this.errorMessage,
    this.deviceType,
    this.newEmail,
    this.useDynamics,
    this.needPhone});

  NewUserFormState copyWith({
    FormStatus? status,
    bool? isFilling,
    String? errorMessage,
    String? deviceType,
    String? newEmail,
    String? useDynamics,
    String? needPhone,
  }){
    return NewUserFormState(
      status: status ?? this.status,
      isFilling: isFilling ?? this.isFilling,
      errorMessage: errorMessage,
      deviceType: deviceType ?? this.deviceType,
      newEmail: newEmail ?? this.newEmail,
      useDynamics: useDynamics ?? this.useDynamics,
      needPhone: needPhone ?? this.needPhone,
    );
}

}

