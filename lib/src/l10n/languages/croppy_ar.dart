import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsAr extends CroppyLocalizations {
  CroppyLocalizationsAr() : super('ar');

  @override
  String get cancelLabel => 'إلغاء';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'حر';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'الأصلي';

  @override
  String get cupertinoResetLabel => 'إعادة الضبط';

  @override
  String get cupertinoSquareAspectRatioLabel => 'مربع';

  @override
  String get doneLabel => 'تم';

  @override
  String get materialFreeformAspectRatioLabel => 'حر';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'قلب إلى وضع ${direction == LocalizationDirection.vertical ? 'عمودي' : 'أفقي'}';

  @override
  String get materialOriginalAspectRatioLabel => 'الأصلي';

  @override
  String get materialResetLabel => 'إعادة الضبط';

  @override
  String get materialSquareAspectRatioLabel => 'مربع';

  @override
  String get saveLabel => 'حفظ';
}
