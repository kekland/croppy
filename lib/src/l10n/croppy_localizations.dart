import 'package:croppy/src/src.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum LocalizationDirection {
  vertical,
  horizontal,
}

abstract class CroppyLocalizations {
  CroppyLocalizations(this.localeName);

  final String localeName;

  static CroppyLocalizations? of(BuildContext context) {
    return Localizations.of<CroppyLocalizations>(context, CroppyLocalizations);
  }

  static const LocalizationsDelegate<CroppyLocalizations> delegate =
      _CroppyLocalizationsDelegate();

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('kk'),
    Locale('ar'),
    Locale('vi'),
    Locale('pt'),
    Locale('es'),
  ];

  /// Defaults to °
  String get degreeSignCharacter => '°';

  /// Defaults to "12°"
  String getRoundedDegrees(double degrees) {
    return '${degrees.round()}$degreeSignCharacter';
  }

  /// en: "Reset"
  String get materialResetLabel;

  /// en: "RESET"
  String get cupertinoResetLabel;

  /// en: "Flip to $direction"
  String materialGetFlipLabel(LocalizationDirection direction);

  /// en: "Free"
  String get materialFreeformAspectRatioLabel;

  /// en: "Original"
  String get materialOriginalAspectRatioLabel;

  /// en: "Square"
  String get materialSquareAspectRatioLabel;

  /// Defaults to "$width:$height"
  String getAspectRatioLabel(int width, int height) => '$width:$height';

  /// en: "Save"
  String get saveLabel;

  /// en: "Done"
  String get doneLabel;

  /// en: "Cancel"
  String get cancelLabel;

  /// en: "FREEFORM"
  String get cupertinoFreeformAspectRatioLabel;

  /// en: "ORIGINAL"
  String get cupertinoOriginalAspectRatioLabel;

  /// en: "SQUARE"
  String get cupertinoSquareAspectRatioLabel;
}

class _CroppyLocalizationsDelegate
    extends LocalizationsDelegate<CroppyLocalizations> {
  const _CroppyLocalizationsDelegate();

  @override
  Future<CroppyLocalizations> load(Locale locale) {
    return SynchronousFuture<CroppyLocalizations>(
      lookupCroppyLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) => true;

  @override
  bool shouldReload(_CroppyLocalizationsDelegate old) => false;
}

CroppyLocalizations lookupCroppyLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return CroppyLocalizationsEn();
    case 'ru':
      return CroppyLocalizationsRu();
    case 'kk':
      return CroppyLocalizationsKk();
    case 'ar':
      return CroppyLocalizationsAr();
    case 'vi':
      return CroppyLocalizationsVi();
    case 'pt':
      return CroppyLocalizationsPt();
  }

  if (kDebugMode) {
    debugPrint(
      'CroppyLocalizations.delegate failed to load locale "$locale". '
      'Falling back to English localizations. You can override the locale '
      'by explicitly passing [locale] when pushing the cropper.',
    );
  }

  return CroppyLocalizationsEn();
}
