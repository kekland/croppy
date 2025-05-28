import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsSk extends CroppyLocalizations {
  CroppyLocalizationsSk() : super('sk');

  @override
  String get cancelLabel => 'Zrušiť';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'VOĽNÝ';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINÁL';

  @override
  String get cupertinoResetLabel => 'RESETOVAŤ';

  @override
  String get cupertinoSquareAspectRatioLabel => 'ŠTVOREC';

  @override
  String get doneLabel => 'Hotovo';

  @override
  String get materialFreeformAspectRatioLabel => 'Voľný';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Preklopiť ${direction == LocalizationDirection.vertical ? 'zvisle' : 'vodorovne'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Originál';

  @override
  String get materialResetLabel => 'Resetovať';

  @override
  String get materialSquareAspectRatioLabel => 'Štvorec';

  @override
  String get saveLabel => 'Uložiť';
}
