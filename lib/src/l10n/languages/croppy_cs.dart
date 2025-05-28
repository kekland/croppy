import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsCs extends CroppyLocalizations {
  CroppyLocalizationsCs() : super('cs');

  @override
  String get cancelLabel => 'Zrušit';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'VOLNÝ';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINÁL';

  @override
  String get cupertinoResetLabel => 'RESETOVAT';

  @override
  String get cupertinoSquareAspectRatioLabel => 'ČTVEREC';

  @override
  String get doneLabel => 'Hotovo';

  @override
  String get materialFreeformAspectRatioLabel => 'Volný';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Překlopit ${direction == LocalizationDirection.vertical ? 'svisle' : 'vodorovně'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Originál';

  @override
  String get materialResetLabel => 'Resetovat';

  @override
  String get materialSquareAspectRatioLabel => 'Čtverec';

  @override
  String get saveLabel => 'Uložit';
}
