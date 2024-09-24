import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsDe extends CroppyLocalizations {
  CroppyLocalizationsDe() : super('de');

  @override
  String get cancelLabel => 'Abbrechen';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'FREIFORM';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINAL';

  @override
  String get cupertinoResetLabel => 'ZURÜCKSETZEN';

  @override
  String get cupertinoSquareAspectRatioLabel => 'QUADRAT';

  @override
  String get doneLabel => 'Fertig';

  @override
  String get materialFreeformAspectRatioLabel => 'Freiform';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      '${direction == LocalizationDirection.vertical ? 'Vertikal' : 'Horizontal'} drehen';

  @override
  String get materialOriginalAspectRatioLabel => 'Original';

  @override
  String get materialResetLabel => 'Zurücksetzen';

  @override
  String get materialSquareAspectRatioLabel => 'Quadrat';

  @override
  String get saveLabel => 'Speichern';
}
