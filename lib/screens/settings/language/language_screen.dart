import 'package:company_portal/providers/locale_provider.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.localeProvider;
    final currentLocale = context.currentLocale();
    final theme = context.theme;
    final local = context.local;
    final backIcon = context.backIcon;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(local.language,style: theme.textTheme.headlineLarge),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(backIcon, color: theme.colorScheme.primary,),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _languageOption('en', local.english, currentLocale == 'en', localeProvider, context, theme),
              const SizedBox(height: 10),
              _languageOption('ar', local.arabic, currentLocale == 'ar', localeProvider, context, theme),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _languageOption(String languageCode, String languageName,
    bool isSelected, LocaleProvider localeProvider,BuildContext context, ThemeData theme) {
  return ListTile(
    onTap: () async {
      localeProvider.setLocale(Locale(languageCode));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LanguageScreen(),
        ),
      );
    },
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    tileColor: isSelected
        ? theme.colorScheme.secondary.withOpacity(0.1)
        : theme.colorScheme.primary.withOpacity(0.1),
    leading: Icon(
      isSelected ? Icons.check_circle : Icons.circle_outlined,
      color:
          isSelected ? theme.colorScheme.secondary : theme.colorScheme.primary,
    ),
    title: Text(
      languageName,
      style: theme.textTheme.displayLarge,
    ),
  );
}
