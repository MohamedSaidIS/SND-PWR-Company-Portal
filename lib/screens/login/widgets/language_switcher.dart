import 'package:company_portal/providers/locale_provider.dart';
import 'package:company_portal/utils/context_extensions.dart';
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

    return Positioned(
      top: 10,
      left: isArabic ? null : 0,
      right: isArabic ? 0 : null,
      child: Row(
        children: [
          IconButton(
            onPressed: onLanguageChanged,
            icon: const Icon(Icons.language, color: Color(0xFF1B818E), size: 30
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Center(
              child: Text(
                currentLocale.toUpperCase() == "AR" ? local.aR : local.eN,
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }
}
