import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsHi extends CroppyLocalizations {
  CroppyLocalizationsHi() : super('hi');

  @override
  String get cancelLabel => 'रद्द करें';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'मुक्त';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'मूल';

  @override
  String get cupertinoResetLabel => 'रीसेट';

  @override
  String get cupertinoSquareAspectRatioLabel => 'वर्ग';

  @override
  String get doneLabel => 'हो गया';

  @override
  String get materialFreeformAspectRatioLabel => 'मुक्त';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      '${direction == LocalizationDirection.vertical ? 'लंबवत' : 'क्षैतिज'} पलटें';

  @override
  String get materialOriginalAspectRatioLabel => 'मूल';

  @override
  String get materialResetLabel => 'रीसेट';

  @override
  String get materialSquareAspectRatioLabel => 'वर्ग';

  @override
  String get saveLabel => 'सहेजें';
}