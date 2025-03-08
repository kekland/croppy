import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsFa extends CroppyLocalizations {
  CroppyLocalizationsFa() : super('fa');

  @override
  String get cancelLabel => 'لغو';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'آزاد';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'اصلی';

  @override
  String get cupertinoResetLabel => 'بازنشانی';

  @override
  String get cupertinoSquareAspectRatioLabel => 'مربع';

  @override
  String get doneLabel => 'تایید';

  @override
  String get materialFreeformAspectRatioLabel => 'آزاد';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'چرخش به ${direction == LocalizationDirection.vertical ? 'عمودی' : 'افقی'}';

  @override
  String get materialOriginalAspectRatioLabel => 'اصلی';

  @override
  String get materialResetLabel => 'بازنشانی';

  @override
  String get materialSquareAspectRatioLabel => 'مربع';

  @override
  String get saveLabel => 'ذخیره';
}
