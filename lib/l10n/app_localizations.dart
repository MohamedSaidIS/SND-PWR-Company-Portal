import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @attendLeaveRequest.
  ///
  /// In en, this message translates to:
  /// **'Attend / Leave'**
  String get attendLeaveRequest;

  /// No description provided for @vacationRequest.
  ///
  /// In en, this message translates to:
  /// **'Vacation \nRequest'**
  String get vacationRequest;

  /// No description provided for @permissionRequest.
  ///
  /// In en, this message translates to:
  /// **'Permission \nRequest'**
  String get permissionRequest;

  /// No description provided for @vacationBalanceRequest.
  ///
  /// In en, this message translates to:
  /// **'Vacation \nBalance'**
  String get vacationBalanceRequest;

  /// No description provided for @vacationRequestLine.
  ///
  /// In en, this message translates to:
  /// **'Vacation Request'**
  String get vacationRequestLine;

  /// No description provided for @permissionRequestLine.
  ///
  /// In en, this message translates to:
  /// **'Permission Request'**
  String get permissionRequestLine;

  /// No description provided for @vacationBalanceRequestLine.
  ///
  /// In en, this message translates to:
  /// **'Vacation Balance'**
  String get vacationBalanceRequestLine;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @managementName.
  ///
  /// In en, this message translates to:
  /// **'Management Name'**
  String get managementName;

  /// No description provided for @departmentName.
  ///
  /// In en, this message translates to:
  /// **'Department Name'**
  String get departmentName;

  /// No description provided for @employeeCode.
  ///
  /// In en, this message translates to:
  /// **'Employee Code'**
  String get employeeCode;

  /// No description provided for @employeeName.
  ///
  /// In en, this message translates to:
  /// **'Employee Name'**
  String get employeeName;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @vacationType.
  ///
  /// In en, this message translates to:
  /// **'Vacation Type'**
  String get vacationType;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @vacationDays.
  ///
  /// In en, this message translates to:
  /// **'Vacation Days'**
  String get vacationDays;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// No description provided for @clearSignature.
  ///
  /// In en, this message translates to:
  /// **'Clear Signature'**
  String get clearSignature;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @vacationRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Vacation request submitted'**
  String get vacationRequestSubmitted;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @apps.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get apps;

  /// No description provided for @kpis.
  ///
  /// In en, this message translates to:
  /// **'KPIs'**
  String get kpis;

  /// No description provided for @kpisDetails.
  ///
  /// In en, this message translates to:
  /// **'KPIs Details'**
  String get kpisDetails;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @userInformation.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInformation;

  /// No description provided for @directReport.
  ///
  /// In en, this message translates to:
  /// **'Direct Reports'**
  String get directReport;

  /// No description provided for @yourTeamMembers.
  ///
  /// In en, this message translates to:
  /// **'Your Team Members'**
  String get yourTeamMembers;

  /// No description provided for @userInfo.
  ///
  /// In en, this message translates to:
  /// **'User Info'**
  String get userInfo;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @managerDetails.
  ///
  /// In en, this message translates to:
  /// **'Manager Details'**
  String get managerDetails;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @thisAppIsNotExists.
  ///
  /// In en, this message translates to:
  /// **'This app is not exists'**
  String get thisAppIsNotExists;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get undo;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @complaintAndSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Complaint and Suggestion'**
  String get complaintAndSuggestion;

  /// No description provided for @complaintSuggestionHeader.
  ///
  /// In en, this message translates to:
  /// **'Complaint / Suggestion'**
  String get complaintSuggestionHeader;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated Successfully'**
  String get profilePhotoUpdated;

  /// No description provided for @uploadPhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload photo failed:'**
  String get uploadPhotoFailed;

  /// No description provided for @fromSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'From submitted successfully!'**
  String get fromSubmittedSuccessfully;

  /// No description provided for @nameOptional.
  ///
  /// In en, this message translates to:
  /// **'Name (Optional)'**
  String get nameOptional;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category *'**
  String get category;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority *'**
  String get priority;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectCategory;

  /// No description provided for @pleaseSelectPriority.
  ///
  /// In en, this message translates to:
  /// **'Please select a priority'**
  String get pleaseSelectPriority;

  /// No description provided for @issueDescription.
  ///
  /// In en, this message translates to:
  /// **'Description *'**
  String get issueDescription;

  /// No description provided for @issueTitle.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get issueTitle;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your title'**
  String get pleaseEnterTitle;

  /// No description provided for @pleaseEnterYourDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter your description'**
  String get pleaseEnterYourDescription;

  /// No description provided for @areYouSureYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// No description provided for @failedToRetrieveAccessToken.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve access token'**
  String get failedToRetrieveAccessToken;

  /// No description provided for @noTeamMembersAssigned.
  ///
  /// In en, this message translates to:
  /// **'No Team Members Assigned'**
  String get noTeamMembersAssigned;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @thereAreCurrentlyNoTeamMembersAssignedToYouForDisplay.
  ///
  /// In en, this message translates to:
  /// **'There are currently no team members assigned to you for display.'**
  String get thereAreCurrentlyNoTeamMembersAssignedToYouForDisplay;

  /// No description provided for @sectionTitleOne.
  ///
  /// In en, this message translates to:
  /// **'Introduction to Al-Sanidi'**
  String get sectionTitleOne;

  /// No description provided for @sectionTextOne.
  ///
  /// In en, this message translates to:
  /// **'Al-Sanidi is one of the foremost names in Saudi Arabia’s outdoor retail market, specializing in trekking tools, camping gear, and adventure equipment. Since its founding, the company has focused on delivering a wide range of durable, high-quality products that cater to the needs of both casual campers and seasoned outdoor enthusiasts. Its product portfolio includes essential items like tents, backpacks, sleeping bags, portable stoves, multi-tools, hiking boots, and other equipment.'**
  String get sectionTextOne;

  /// No description provided for @sectionTitleTwo.
  ///
  /// In en, this message translates to:
  /// **'Vision and Market Presence'**
  String get sectionTitleTwo;

  /// No description provided for @sectionTextTwo.
  ///
  /// In en, this message translates to:
  /// **'Al-Sanidi’s vision is rooted in becoming the ultimate destination for adventurers, offering not only products but also expertise in outdoor activities. The company has grown from a single store to a robust network of physical retail outlets spread across multiple regions of Saudi Arabia, supported by a dynamic online platform that serves customers both locally and across the Middle East. By blending in-store services with e-commerce'**
  String get sectionTextTwo;

  /// No description provided for @sectionTextTwoPartTwo.
  ///
  /// In en, this message translates to:
  /// **'Al-Sanidi offers a seamless omnichannel shopping experience. In recent years, Al-Sanidi has increasingly focused on expanding its market share through innovative product offerings, such as high-tech camping gear, solar-powered gadgets, and eco-friendly tools. This has allowed the company to differentiate itself in a competitive retail landscape, while maintaining a reputation for reliability and innovative products.'**
  String get sectionTextTwoPartTwo;

  /// No description provided for @sectionTitleThree.
  ///
  /// In en, this message translates to:
  /// **'Commitment to Quality and Customer Experience'**
  String get sectionTitleThree;

  /// No description provided for @sectionTextThree.
  ///
  /// In en, this message translates to:
  /// **'Al-Sanidi is committed to ensuring that every product meets rigorous quality standards. This emphasis on quality is reflected in its partnerships with globally renowned brands known for their durability and innovation. Whether it is providing the most lightweight tents for backpackers or offering durable trekking poles for rugged terrains. Al-Sanidi focuses on curating products that align with the specific needs of outdoor adventurers in the Middle East.'**
  String get sectionTextThree;

  /// No description provided for @sectionTextThreePartThree.
  ///
  /// In en, this message translates to:
  /// **'Moreover, customer experience remains at the heart of the company’s business strategy. With a diverse clientele ranging from families planning weekend camping trips to professional hikers exploring remote regions, Al-Sanidi takes pride in offering personalized recommendations and in-store consultations.'**
  String get sectionTextThreePartThree;

  /// No description provided for @it.
  ///
  /// In en, this message translates to:
  /// **'IT'**
  String get it;

  /// No description provided for @marketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get marketing;

  /// No description provided for @customerService.
  ///
  /// In en, this message translates to:
  /// **'Customer Service'**
  String get customerService;

  /// No description provided for @hr.
  ///
  /// In en, this message translates to:
  /// **'HR'**
  String get hr;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @statusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get statusNew;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get statusCanceled;

  /// No description provided for @statusDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Duplicated'**
  String get statusDuplicated;

  /// No description provided for @statusDelay.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get statusDelay;

  /// No description provided for @issueID.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get issueID;

  /// No description provided for @issue_Title.
  ///
  /// In en, this message translates to:
  /// **'Issue Title'**
  String get issue_Title;

  /// No description provided for @complaint.
  ///
  /// In en, this message translates to:
  /// **'Complaint'**
  String get complaint;

  /// No description provided for @suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestion;

  /// No description provided for @aR.
  ///
  /// In en, this message translates to:
  /// **'AR'**
  String get aR;

  /// No description provided for @eN.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get eN;

  /// No description provided for @editImage.
  ///
  /// In en, this message translates to:
  /// **'Edit Image'**
  String get editImage;

  /// No description provided for @openingApp.
  ///
  /// In en, this message translates to:
  /// **'Opening App'**
  String get openingApp;

  /// No description provided for @issue_details.
  ///
  /// In en, this message translates to:
  /// **'Issue Details'**
  String get issue_details;

  /// No description provided for @exceeded.
  ///
  /// In en, this message translates to:
  /// **'Exceeded'**
  String get exceeded;

  /// No description provided for @reached.
  ///
  /// In en, this message translates to:
  /// **'Reached'**
  String get reached;

  /// No description provided for @near.
  ///
  /// In en, this message translates to:
  /// **'Near'**
  String get near;

  /// No description provided for @below.
  ///
  /// In en, this message translates to:
  /// **'Below'**
  String get below;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @dailyKpi.
  ///
  /// In en, this message translates to:
  /// **'Daily KPI'**
  String get dailyKpi;

  /// No description provided for @weeklyKpi.
  ///
  /// In en, this message translates to:
  /// **'Weekly KPI'**
  String get weeklyKpi;

  /// No description provided for @monthlyKpi.
  ///
  /// In en, this message translates to:
  /// **'Monthly KPI'**
  String get monthlyKpi;

  /// No description provided for @uat.
  ///
  /// In en, this message translates to:
  /// **'UAT'**
  String get uat;

  /// No description provided for @prod.
  ///
  /// In en, this message translates to:
  /// **'Prod'**
  String get prod;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @achieved.
  ///
  /// In en, this message translates to:
  /// **'Achieved'**
  String get achieved;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
