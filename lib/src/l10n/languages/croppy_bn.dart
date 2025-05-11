import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsBn extends CroppyLocalizations {
  CroppyLocalizationsBn() : super('bn');

  @override
  String get cancelLabel => 'বাতিল';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'মুক্ত';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'মূল';

  @override
  String get cupertinoResetLabel => 'রিসেট';

  @override
  String get cupertinoSquareAspectRatioLabel => 'বর্গ';

  @override
  String get doneLabel => 'সম্পন্ন';

  @override
  String get materialFreeformAspectRatioLabel => 'মুক্ত';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      '${direction == LocalizationDirection.vertical ? 'উল্লম্বভাবে' : 'অনুভূমিকভাবে'} উল্টান';

  @override
  String get materialOriginalAspectRatioLabel => 'মূল';

  @override
  String get materialResetLabel => 'রিসেট';

  @override
  String get materialSquareAspectRatioLabel => 'বর্গ';

  @override
  String get saveLabel => 'সংরক্ষণ';
}
