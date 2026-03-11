import 'package:flutter/material.dart';

import '../../../../utils/export_import.dart';

class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({super.key});

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  String? selectedCode;

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.localeProvider;
    final local = context.local;
    final theme = context.theme;
    final isLandScape = context.isLandScape();
    final isEnglish = context.isEnglish();
    selectedCode = context.currentLocale();

    double iconSize = (isLandScape
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width) *
        0.07;

    double textSize = (isLandScape
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width) *
        0.045;

    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.language,
            color: const Color(0xFF1B818E),
            size: iconSize,
          ),
          onPressed: () =>
              _showLanguageBottomSheet(context, localeProvider, local, theme),
        ),
        Transform.translate(
          offset: Offset(!isEnglish ? 7 : -7, 0),
          child: Text(
            selectedLocaleText(local, selectedCode!),
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: textSize,
            ),
          ),
        )
      ],
    );
  }

  void _showLanguageBottomSheet(BuildContext context,
      LocaleProvider localeProvider, AppLocalizations local, ThemeData theme) {
    final languages = getLanguage(local);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((lang) {
              final isSelected = selectedCode == lang["code"];
              return GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  showLoadingDialog(context, theme);

                  await Future.delayed(const Duration(milliseconds: 300));

                  selectedCode = lang["code"];
                  localeProvider.setLocale(Locale(lang["code"]!));

                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? const Color(0xFF1B818E) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    lang["label"]!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

void showLoadingDialog(BuildContext context, ThemeData theme) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: theme.colorScheme.surface,
        child: const Center(
          child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(Color(0xFF1B818E))),
        ),
      );
    },
  );
}

String selectedLocaleText(AppLocalizations local, String currentLocale) {
  return switch (currentLocale) {
    'en' => local.eN,
    'ar' => local.aR,
    'ur' => local.uR,
    _ => throw Exception('Unknown locale: $currentLocale'),
  };
}
