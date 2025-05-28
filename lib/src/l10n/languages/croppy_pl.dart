import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsPl extends CroppyLocalizations {
  CroppyLocalizationsPl() : super('pl');

  @override
  String get cancelLabel => 'Anuluj';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'DOWOLNY';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORYGINALNY';

  @override
  String get cupertinoResetLabel => 'RESETUJ';

  @override
  String get cupertinoSquareAspectRatioLabel => 'KWADRAT';

  @override
  String get doneLabel => 'Gotowe';

  @override
  String get materialFreeformAspectRatioLabel => 'Dowolny';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Obróć ${direction == LocalizationDirection.vertical ? 'pionowo' : 'poziomo'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Oryginalny';

  @override
  String get materialResetLabel => 'Resetuj';

  @override
  String get materialSquareAspectRatioLabel => 'Kwadrat';

  @override
  String get saveLabel => 'Zapisz';
}
