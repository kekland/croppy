import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsNl extends CroppyLocalizations {
  CroppyLocalizationsNl() : super('nl');

  @override
  String get cancelLabel => 'Annuleren';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'VRIJE VORM';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINEEL';

  @override
  String get cupertinoResetLabel => 'RESET';

  @override
  String get cupertinoSquareAspectRatioLabel => 'VIERKANT';

  @override
  String get doneLabel => 'Klaar';

  @override
  String get materialFreeformAspectRatioLabel => 'Vrije vorm';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Spiegelen ${direction == LocalizationDirection.vertical ? 'verticaal' : 'horizontaal'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Origineel';

  @override
  String get materialResetLabel => 'Reset';

  @override
  String get materialSquareAspectRatioLabel => 'Vierkant';

  @override
  String get saveLabel => 'Opslaan';
}
