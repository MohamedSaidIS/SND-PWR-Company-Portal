import '../../../../utils/export_import.dart';
import 'package:flutter/material.dart';

class LanguageSwitcher extends StatelessWidget {
  final LocaleProvider localeProvider;
  final String currentLocale;
  final VoidCallback onLanguageChanged;

  const LanguageSwitcher({
    super.key,
    required this.localeProvider,
    required this.currentLocale,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLocale == 'ar';
    final local = context.local;
    final theme = context.theme;

    return Row(
      children: [
        IconButton(
          onPressed: onLanguageChanged,
          icon: Icon(Icons.language, color: const Color(0xFF1B818E), size: MediaQuery.of(context).size.width * 0.07
          ),
        ),
        Transform.translate(
          offset: Offset(isArabic ? 7: -7, 0),
          child: Text(
            currentLocale.toUpperCase() == "AR" ? local.aR : local.eN,
            style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width * 0.045),
          ),
        )
      ],
    );
  }
}
