part of 'new_user_form_bloc.dart';

sealed class NewUserFormEvent {}

class SubmitNewUserFormEvent extends NewUserFormEvent{
  final NewUserItem item;
  final bool isUpdate;
  final int itemId;

  SubmitNewUserFormEvent({
    required this.item,
    this.isUpdate = false,
    this.itemId = -1,
});
}

class ChangeDeviceTypeEvent extends NewUserFormEvent{
  final String selectedType;

  ChangeDeviceTypeEvent(this.selectedType);
}

class ChangeNewEmailEvent extends NewUserFormEvent{
  final String newEmail;

  ChangeNewEmailEvent(this.newEmail);
}

class ChangeUseDynamicsEvent extends NewUserFormEvent{
  final String useDynamics;

  ChangeUseDynamicsEvent(this.useDynamics);
}

class ChangeNeedPhoneEvent extends NewUserFormEvent{
  final String needPhone;

  ChangeNeedPhoneEvent(this.needPhone);
}

