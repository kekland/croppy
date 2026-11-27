import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsIt extends CroppyLocalizations {
  CroppyLocalizationsIt() : super('it');

  @override
  String get cancelLabel => 'Annulla';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'LIBERO';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINALE';

  @override
  String get cupertinoResetLabel => 'RIPRISTINA';

  @override
  String get cupertinoSquareAspectRatioLabel => 'QUADRATO';

  @override
  String get doneLabel => 'Fatto';

  @override
  String get materialFreeformAspectRatioLabel => 'Libero';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Capovolgi ${direction == LocalizationDirection.vertical ? 'verticalmente' : 'orizzontalmente'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Originale';

  @override
  String get materialResetLabel => 'Ripristina';

  @override
  String get materialSquareAspectRatioLabel => 'Quadrato';

  @override
  String get saveLabel => 'Salva';
}
