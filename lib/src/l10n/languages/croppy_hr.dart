import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsHr extends CroppyLocalizations {
  CroppyLocalizationsHr() : super('hr');

  @override
  String get cancelLabel => 'Odustani';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'SLOBODNO';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINAL';

  @override
  String get cupertinoResetLabel => 'PONIŠTI';

  @override
  String get cupertinoSquareAspectRatioLabel => 'KVADRAT';

  @override
  String get doneLabel => 'Gotovo';

  @override
  String get materialFreeformAspectRatioLabel => 'Slobodno';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Okreni ${direction == LocalizationDirection.vertical ? 'okomito' : 'vodoravno'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Original';

  @override
  String get materialResetLabel => 'Poništi';

  @override
  String get materialSquareAspectRatioLabel => 'Kvadrat';

  @override
  String get saveLabel => 'Spremi';
}
