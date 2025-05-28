import 'package:croppy/src/src.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum LocalizationDirection { vertical, horizontal }

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
    Locale('he'),
    Locale('zh'),
    Locale('de'),
    Locale('fa'),
    Locale('it'),
    Locale('sl'),
    Locale('hr'),
    Locale('fr'),
    Locale('pl'),
    Locale('sk'),
    Locale('cs'),
    Locale('bs'),
    Locale('sr'),
    Locale('tr'),
    Locale('uk'),
    Locale('sv'),
    Locale('no'),
    Locale('hu'),
    Locale('nl'),
    Locale('ja'),
    Locale('hi'),
    Locale('ko'),
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
    case 'he':
      return CroppyLocalizationsHe();
    case 'es':
      return CroppyLocalizationsEs();
    case 'zh':
      return CroppyLocalizationsZh();
    case 'de':
      return CroppyLocalizationsDe();
    case 'fa':
      return CroppyLocalizationsFa();
    case 'it':
      return CroppyLocalizationsIt();
    case 'sl':
      return CroppyLocalizationsSl();
    case 'hr':
      return CroppyLocalizationsHr();
    case 'fr':
      return CroppyLocalizationsFr();
    case 'pl':
      return CroppyLocalizationsPl();
    case 'sk':
      return CroppyLocalizationsSk();
    case 'cs':
      return CroppyLocalizationsCs();
    case 'bs':
      return CroppyLocalizationsBs();
    case 'sr':
      return CroppyLocalizationsSr();
    case 'tr':
      return CroppyLocalizationsTr();
    case 'uk':
      return CroppyLocalizationsUk();
    case 'sv':
      return CroppyLocalizationsSv();
    case 'no':
      return CroppyLocalizationsNo();
    case 'hu':
      return CroppyLocalizationsHu();
    case 'nl':
      return CroppyLocalizationsNl();
    case 'ja':
      return CroppyLocalizationsJa();
    case 'hi':
      return CroppyLocalizationsHi();
    case 'ko':
      return CroppyLocalizationsKo();
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
