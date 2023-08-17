import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsEn extends CroppyLocalizations {
  CroppyLocalizationsEn() : super('en');

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'FREEFORM';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINAL';

  @override
  String get cupertinoResetLabel => 'RESET';

  @override
  String get cupertinoSquareAspectRatioLabel => 'SQUARE';

  @override
  String get doneLabel => 'Done';

  @override
  String get materialFreeformAspectRatioLabel => 'Free';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Flip to ${direction == LocalizationDirection.vertical ? 'vertical' : 'horizontal'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Original';

  @override
  String get materialResetLabel => 'Reset';

  @override
  String get materialSquareAspectRatioLabel => 'Square';

  @override
  String get saveLabel => 'Save';
}
