import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsSv extends CroppyLocalizations {
  CroppyLocalizationsSv() : super('sv');

  @override
  String get cancelLabel => 'Avbryt';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'FRIHAND';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINAL';

  @override
  String get cupertinoResetLabel => 'ÅTERSTÄLL';

  @override
  String get cupertinoSquareAspectRatioLabel => 'KVADRAT';

  @override
  String get doneLabel => 'Klar';

  @override
  String get materialFreeformAspectRatioLabel => 'Frihand';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Vänd ${direction == LocalizationDirection.vertical ? 'vertikalt' : 'horisontellt'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Original';

  @override
  String get materialResetLabel => 'Återställ';

  @override
  String get materialSquareAspectRatioLabel => 'Kvadrat';

  @override
  String get saveLabel => 'Spara';
}
