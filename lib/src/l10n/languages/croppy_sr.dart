import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsSr extends CroppyLocalizations {
  CroppyLocalizationsSr() : super('sr');

  @override
  String get cancelLabel => 'Odustani';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'SLOBODNO';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINAL';

  @override
  String get cupertinoResetLabel => 'RESETUJ';

  @override
  String get cupertinoSquareAspectRatioLabel => 'KVADRAT';

  @override
  String get doneLabel => 'Gotovo';

  @override
  String get materialFreeformAspectRatioLabel => 'Slobodno';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Okreni ${direction == LocalizationDirection.vertical ? 'vertikalno' : 'horizontalno'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Original';

  @override
  String get materialResetLabel => 'Resetuj';

  @override
  String get materialSquareAspectRatioLabel => 'Kvadrat';

  @override
  String get saveLabel => 'Sačuvaj';
}
