import 'package:croppy/croppy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyCroppyLocalizationsDelegate
    extends LocalizationsDelegate<CroppyLocalizations> {
  @override
  bool isSupported(Locale locale) =>
      CroppyLocalizations.supportedLocales.contains(locale);

  @override
  Future<CroppyLocalizations> load(Locale locale) {
    if (locale.languageCode == 'en') {
      return SynchronousFuture(CroppyLocalizationsPirateEn());
    }

    return SynchronousFuture(lookupCroppyLocalizations(locale));
  }

  @override
  bool shouldReload(MyCroppyLocalizationsDelegate old) => false;
}

/// The translations for English (`en`) - for pirates cruising on a ship.
class CroppyLocalizationsPirateEn extends CroppyLocalizations {
  CroppyLocalizationsPirateEn() : super('en');

  @override
  String get cancelLabel => 'Scuttle';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'FREEFORM';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINAL';

  @override
  String get cupertinoResetLabel => 'ABORT';

  @override
  String get cupertinoSquareAspectRatioLabel => 'SQUARE';

  @override
  String get doneLabel => 'Done';

  @override
  String get materialFreeformAspectRatioLabel => 'Free';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) {
    switch (direction) {
      case LocalizationDirection.horizontal:
        return 'Turn to starboard';

      case LocalizationDirection.vertical:
        return 'Turn to bow';
    }
  }

  @override
  String get materialOriginalAspectRatioLabel => 'Original';

  @override
  String get materialResetLabel => 'Abort';

  @override
  String get materialSquareAspectRatioLabel => 'Square';

  @override
  String get saveLabel => 'Save';
}
