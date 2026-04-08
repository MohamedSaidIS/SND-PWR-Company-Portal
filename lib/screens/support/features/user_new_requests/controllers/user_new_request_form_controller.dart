import 'package:company_portal/screens/support/features/user_new_requests/bloc/new_user_form_bloc/new_user_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:company_portal/utils/export_import.dart';
class UserNewRequestFormController {
  final BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final joiningDate = TextEditingController();
  final englishName = TextEditingController();
  final arabicName = TextEditingController();
  final location = TextEditingController();
  final jobTitle = TextEditingController();
  final mobile = TextEditingController();
  final department = TextEditingController();
  final manager = TextEditingController();
  final laptopNeed = TextEditingController();
  final specialSpecs = TextEditingController();
  final software = TextEditingController();
  final currentMail = TextEditingController();
  final specifyNewMail = TextEditingController();
  final specifyDynamics = TextEditingController();

  UserNewRequestFormController(NewUserItem? newUserItem, {required this.context}) {
    if (newUserItem != null) fillForm(newUserItem);
  }

  void fillForm(NewUserItem? req) {
    if (req == null) return;
    title.text = req.title ?? '';
    joiningDate.text = DatesHelper.dashedFormatting(req.joiningDate, context.currentLocale());
    location.text = req.location ?? '';
    englishName.text = req.enName ?? '';
    arabicName.text = req.arName ?? '';
    jobTitle.text = req.jobTitle ?? '';
    mobile.text = req.phoneNo ?? '';
    department.text = req.department ?? '';
    laptopNeed.text = req.laptopNeeds ?? '';
    specialSpecs.text = req.specialSpecs ?? '';
    software.text = req.specificSoftware ?? '';
    currentMail.text = req.currentEmailToUse ?? '';
    specifyNewMail.text = req.specifyNeedForNewEmail ?? '';
    specifyDynamics.text = req.specifyDynamicsRole ?? '';
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if(!context.mounted) return;
      joiningDate.text = DatesHelper.dashedFormatting(picked, context.currentLocale());
    }
  }

  void snackBar(AppLocalizations local, bool success, NewUserItem? request){
    if (request == null) clearData();
    AppNotifier.snackBar(context, success? local.fromSubmittedSuccessfully: local.somethingWentWrong,
      success? SnackBarType.success: SnackBarType.error,
    );
  }

  NewUserItem buildRequest({required int ensureUserId, required NewUserFormState state}) {
    final parsedDate = DatesHelper.parseTimeToSend(joiningDate.text);
    return NewUserItem(
      id: -1,
      title: title.text,
      joiningDate: parsedDate,
      location: location.text,
      enName: englishName.text,
      arName: arabicName.text,
      jobTitle: jobTitle.text,
      phoneNo: mobile.text,
      department: department.text,
      deviceRequestType: state.deviceType,
      newEmailRequest:  state.newEmail,
      requestDynamicsAccount:  state.useDynamics,
      requestPhoneLine:  state.needPhone,
      directManagerId: ensureUserId,
      laptopNeeds: laptopNeed.text,
      specialSpecs: specialSpecs.text,
      specificSoftware: software.text,
      currentEmailToUse: currentMail.text,
      specifyNeedForNewEmail: specifyNewMail.text,
      specifyDynamicsRole: specifyDynamics.text,
    );
  }


  void clearData() {
    title.clear();
    joiningDate.clear();
    englishName.clear();
    arabicName.clear();
    location.clear();
    jobTitle.clear();
    mobile.clear();
    department.clear();
    manager.clear();
    laptopNeed.clear();
    specialSpecs.clear();
    software.clear();
    currentMail.clear();
    specifyNewMail.clear();
    specifyDynamics.clear();
  }
}
