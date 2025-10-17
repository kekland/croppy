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
  String materialGetFlipLabel(LocalizationDirection direction) {
    switch (direction) {
      case LocalizationDirection.horizontal:
        return 'Obróć w poziomie';
      case LocalizationDirection.vertical:
        return 'Obróć w pionie';
    }
  }

  @override
  String get materialOriginalAspectRatioLabel => 'Oryginał';

  @override
  String get materialResetLabel => 'Resetuj';

  @override
  String get materialSquareAspectRatioLabel => 'Kwadrat';

  @override
  String get saveLabel => 'Zapisz';
}