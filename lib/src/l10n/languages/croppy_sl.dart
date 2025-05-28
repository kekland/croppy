import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsSl extends CroppyLocalizations {
  CroppyLocalizationsSl() : super('sl');

  @override
  String get cancelLabel => 'Prekliči';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'PROSTO';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'IZVIRNO';

  @override
  String get cupertinoResetLabel => 'PONASTAVI';

  @override
  String get cupertinoSquareAspectRatioLabel => 'KVADRAT';

  @override
  String get doneLabel => 'Končano';

  @override
  String get materialFreeformAspectRatioLabel => 'Prosto';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Obrni ${direction == LocalizationDirection.vertical ? 'navpično' : 'vodoravno'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Izvirno';

  @override
  String get materialResetLabel => 'Ponastavi';

  @override
  String get materialSquareAspectRatioLabel => 'Kvadrat';

  @override
  String get saveLabel => 'Shrani';
}
