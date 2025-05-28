import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsNo extends CroppyLocalizations {
  CroppyLocalizationsNo() : super('no');

  @override
  String get cancelLabel => 'Avbryt';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'FRIFORM';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINAL';

  @override
  String get cupertinoResetLabel => 'TILBAKESTILL';

  @override
  String get cupertinoSquareAspectRatioLabel => 'KVADRAT';

  @override
  String get doneLabel => 'Ferdig';

  @override
  String get materialFreeformAspectRatioLabel => 'Friform';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Vend ${direction == LocalizationDirection.vertical ? 'vertikalt' : 'horisontalt'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Original';

  @override
  String get materialResetLabel => 'Tilbakestill';

  @override
  String get materialSquareAspectRatioLabel => 'Kvadrat';

  @override
  String get saveLabel => 'Lagre';
}
