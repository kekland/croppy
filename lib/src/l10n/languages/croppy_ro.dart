import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsRo extends CroppyLocalizations {
  CroppyLocalizationsRo() : super('ro');

  @override
  String get cancelLabel => 'Anulează';

  @override
  String get saveLabel => 'Salvează';

  @override
  String get doneLabel => 'OK';

  @override
  String get materialResetLabel => 'Reset';

  @override
  String get materialFreeformAspectRatioLabel => 'Liber';

  @override
  String get materialOriginalAspectRatioLabel => 'Original';

  @override
  String get materialSquareAspectRatioLabel => 'Pătrat';

  @override
  String get cupertinoResetLabel => 'RESET';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'FORMĂ LIBERĂ';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINAL';

  @override
  String get cupertinoSquareAspectRatioLabel => 'PĂTRAT';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) {
    return switch (direction) {
      LocalizationDirection.horizontal => 'Întoarce pe orizontală',
      LocalizationDirection.vertical => 'Întoarce pe verticală'
    };
  }
}
