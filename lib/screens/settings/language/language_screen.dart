import 'package:flutter/material.dart';

import '../../../utils/export_import.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? selectedCode;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final localeProvider = context.localeProvider;
    selectedCode = context.currentLocale();

    final languages = getLanguage(local);

    return Scaffold(
      appBar: CustomAppBar(
        title: local.language,
        backBtn: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: List.generate(languages.length, (index) {
            final lang = languages[index];
            return buildLanguageOption(
              index,
              theme,
              lang["code"]!,
              lang["label"]!,
              selectedCode == lang["code"],
              (code) {
                selectedCode = code;
                localeProvider.setLocale(Locale(code));
              },
            );
          }),
        ),
      ),
    );
  }
}

Widget buildLanguageOption(
  int index,
  ThemeData theme,
  String languageCode,
  String languageName,
  bool isSelected,
  Function(String) onSelected,
) {
  return CardSlideAnimation(
    index: index,
    child: GestureDetector(
      onTap: () => onSelected(languageCode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.secondary.withAlpha(30)
              : theme.colorScheme.primary.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                key: ValueKey(isSelected),
                color: isSelected
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              languageName,
              style: theme.textTheme.displayLarge,
            ),
          ],
        ),
      ),
    ),
  );
}
