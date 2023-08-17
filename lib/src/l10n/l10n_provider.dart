import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class CroppyLocalizationProvider extends StatelessWidget {
  const CroppyLocalizationProvider({
    super.key,
    required this.child,
    this.locale,
  });

  factory CroppyLocalizationProvider.passthrough(
    BuildContext context, {
    required Widget child,
  }) {
    return CroppyLocalizationProvider(
      locale: Localizations.localeOf(context),
      child: child,
    );
  }

  final Locale? locale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = CroppyLocalizations.of(context);

    if (l10n != null && locale == null) {
      return child;
    } else {
      return Localizations.override(
        context: context,
        delegates: l10n == null ? const [CroppyLocalizations.delegate] : null,
        locale: locale,
        child: child,
      );
    }
  }
}
