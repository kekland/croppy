import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsHe extends CroppyLocalizations {
  CroppyLocalizationsHe() : super('he');

  @override
  String get cancelLabel => 'ביטול';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'חופשי';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'מקור';

  @override
  String get cupertinoResetLabel => 'איפוס';

  @override
  String get cupertinoSquareAspectRatioLabel => 'ריבועי';

  @override
  String get doneLabel => 'סיימתי';

  @override
  String get materialFreeformAspectRatioLabel => 'חופשי';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'הזז ${direction == LocalizationDirection.vertical ? 'לאורך' : 'לרוחב'}';

  @override
  String get materialOriginalAspectRatioLabel => 'מקורי';

  @override
  String get materialResetLabel => 'איפוס';

  @override
  String get materialSquareAspectRatioLabel => 'ריבוע';

  @override
  String get saveLabel => 'לשמירה';
}
