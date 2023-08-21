import 'package:croppy/src/src.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

enum LocalizationDirection {
  vertical,
  horizontal,
}

abstract class CroppyLocalizations {
  CroppyLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(
          locale.toString(),
        );

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
  bool isSupported(Locale locale) => CroppyLocalizations.supportedLocales
      .map((v) => v.languageCode)
      .contains(locale.languageCode);

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
  }

  throw FlutterError(
    'CroppyLocalizations.delegate failed to load unsupported locale "$locale".'
    'Please make sure to include [CroppyLocalizations.delegate] in your '
    'app\'s `localizationDelegates` list. ',
  );
}
