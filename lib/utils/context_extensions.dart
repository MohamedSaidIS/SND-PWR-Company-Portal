import 'package:company_portal/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../../l10n/app_localizations.dart';

extension ContextHelper on BuildContext{

  ThemeProvider get themeProvider => read<ThemeProvider>();
  ThemeData get theme => Theme.of(this);
  AppLocalizations get local => AppLocalizations.of(this)!;
  LocaleProvider get localeProvider => read<LocaleProvider>();
  IconData get backIcon => isArabic() ? LineAwesomeIcons.angle_right_solid : LineAwesomeIcons.angle_left_solid;
  IconData get itemArrowIcon => isArabic() ? LineAwesomeIcons.angle_left_solid : LineAwesomeIcons.angle_right_solid;
  IconData get loginArrowIcon => isArabic() ? LineAwesomeIcons.arrow_left_solid : LineAwesomeIcons.arrow_right_solid;
  IconData get themeIcon => isDark() ? LineAwesomeIcons.sun : LineAwesomeIcons.moon;
  Alignment get alignment => isArabic() ? Alignment.centerRight : Alignment.centerLeft;
  double? get positionRight => isArabic() ? null : 0 ;
  double? get positionLeft => isArabic() ? 0 : null;
  String currentLocale() => localeProvider.locale.languageCode;
  bool isDark() => themeProvider.isDark;
  bool isArabic() => currentLocale() == "ar";
  bool isTablet() => MediaQuery.of(this).size.width >= 600;
  bool isLandScape() => MediaQuery.of(this).orientation == Orientation.landscape;


}