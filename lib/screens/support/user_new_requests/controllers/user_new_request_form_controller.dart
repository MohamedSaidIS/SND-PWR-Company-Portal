import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/app_notifier.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/context_extensions.dart';
import '../../../../../models/remote/new_user_request.dart';
import '../../../../../providers/new_user_request_provider.dart';
import '../../../../../providers/user_info_provider.dart';
import '../../../../../l10n/app_localizations.dart';

class UserNewRequestFormController {
  final BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isFilling = false;

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

  String? deviceType, newEmail, useDynamics, needPhone;

  UserNewRequestFormController(this.context, dynamic widget) {
    final userInfo = context.read<UserInfoProvider>().userInfo;
    manager.text = userInfo?.mail ?? "";
    print("Request ${widget.newUserRequest}");
    if (widget.newUserRequest != null) fillForm(widget.newUserRequest);
  }

  void fillForm(NewUserRequest? req) {
    print("Request ${req}");
    if (req == null) return;
    isFilling = true;
    title.text = req.title ?? '';
    joiningDate.text = DateFormat('dd-MM-yyyy', context.currentLocale())
        .format(req.joiningDate);
    location.text = req.location ?? '';
    englishName.text = req.enName ?? '';
    arabicName.text = req.arName ?? '';
    jobTitle.text = req.jobTitle ?? '';
    mobile.text = req.phoneNo ?? '';
    department.text = req.department ?? '';
    deviceType = req.deviceRequestType;
    newEmail = req.newEmailRequest;
    useDynamics = req.requestDynamicsAccount;
    needPhone = req.requestPhoneLine;
    laptopNeed.text = req.laptopNeeds ?? '';
    specialSpecs.text = req.specialSpecs ?? '';
    software.text = req.specificSoftware ?? '';
    currentMail.text = req.currentEmailToUse ?? '';
    specifyNewMail.text = req.specifyNeedForNewEmail ?? '';
    specifyDynamics.text = req.specifyDynamicsRole ?? '';

    isFilling = false;
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      joiningDate.text =
          DateFormat('dd-MM-yyyy', context.currentLocale()).format(picked);
    }
  }

  Future<void> submitForm(
    AppLocalizations local,
    NewUserRequest? request,
    int ensureUserId,
  ) async {
    print("Validating form...");
    final isValid = formKey.currentState?.validate() ?? false;
    print("Form valid? $isValid");

    if (!isValid) {
      AppNotifier.snackBar(
          context, local.pleaseFillAllFields, SnackBarType.warning);
      return;
    }

    final provider = context.read<NewUserRequestProvider>();
    try {
      final parsed = DateFormat('dd-MM-yyyy').parse(joiningDate.text);
      final success = request != null
          ? await provider.updateNewUserRequest(
              request.id, _buildRequest(parsed, ensureUserId))
          : await provider
              .createNewUserRequest(_buildRequest(parsed, ensureUserId));

      if (success) {
        if (request == null) clearData();
        AppNotifier.snackBar(
          context,
          local.fromSubmittedSuccessfully,
          SnackBarType.success,
        );
      }
    } catch (e) {
      AppNotifier.snackBar(
        context,
        local.somethingWentWrong,
        SnackBarType.error,
      );
    }
  }

  NewUserRequest _buildRequest(DateTime date, int ensureUserId) =>
      NewUserRequest(
        id: -1,
        title: title.text,
        joiningDate: date,
        location: location.text,
        enName: englishName.text,
        arName: arabicName.text,
        jobTitle: jobTitle.text,
        phoneNo: mobile.text,
        department: department.text,
        deviceRequestType: deviceType,
        newEmailRequest: newEmail,
        requestDynamicsAccount: useDynamics,
        requestPhoneLine: needPhone,
        directManagerId: ensureUserId,
        laptopNeeds: laptopNeed.text,
        specialSpecs: specialSpecs.text,
        specificSoftware: software.text,
        currentEmailToUse: currentMail.text,
        specifyNeedForNewEmail: specifyNewMail.text,
        specifyDynamicsRole: specifyDynamics.text,
      );

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

    deviceType = null;
    newEmail = null;
    useDynamics = null;
    needPhone = null;
  }
}
