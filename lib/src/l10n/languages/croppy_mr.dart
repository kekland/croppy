import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsMr extends CroppyLocalizations {
  CroppyLocalizationsMr() : super('mr');

  @override
  String get cancelLabel => 'रद्द करा';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'मुक्त';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'मूळ';

  @override
  String get cupertinoResetLabel => 'रीसेट';

  @override
  String get cupertinoSquareAspectRatioLabel => 'चौरस';

  @override
  String get doneLabel => 'पूर्ण';

  @override
  String get materialFreeformAspectRatioLabel => 'मुक्त';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      '${direction == LocalizationDirection.vertical ? 'उभे' : 'आडवे'} फिरवा';

  @override
  String get materialOriginalAspectRatioLabel => 'मूळ';

  @override
  String get materialResetLabel => 'रीसेट';

  @override
  String get materialSquareAspectRatioLabel => 'चौरस';

  @override
  String get saveLabel => 'जतन करा';
}