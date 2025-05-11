import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsTe extends CroppyLocalizations {
  CroppyLocalizationsTe() : super('te');

  @override
  String get cancelLabel => 'రద్దు చేయి';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'స్వేచ్ఛా';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'అసలు';

  @override
  String get cupertinoResetLabel => 'రీసెట్';

  @override
  String get cupertinoSquareAspectRatioLabel => 'చదరపు';

  @override
  String get doneLabel => 'పూర్తయింది';

  @override
  String get materialFreeformAspectRatioLabel => 'స్వేచ్ఛా';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      '${direction == LocalizationDirection.vertical ? 'నిలువుగా' : 'అడ్డంగా'} తిప్పు';

  @override
  String get materialOriginalAspectRatioLabel => 'అసలు';

  @override
  String get materialResetLabel => 'రీసెట్';

  @override
  String get materialSquareAspectRatioLabel => 'చదరపు';

  @override
  String get saveLabel => 'సేవ్';
}