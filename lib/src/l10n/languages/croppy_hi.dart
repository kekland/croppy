import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsHi extends CroppyLocalizations {
  CroppyLocalizationsHi() : super('hi');

  @override
  String get cancelLabel => 'रद्द करें';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'स्वतंत्र';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'मूल';

  @override
  String get cupertinoResetLabel => 'रीसेट';

  @override
  String get cupertinoSquareAspectRatioLabel => 'वर्ग';

  @override
  String get doneLabel => 'पूर्ण';

  @override
  String get materialFreeformAspectRatioLabel => 'स्वतंत्र';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      '${direction == LocalizationDirection.vertical ? 'ऊर्ध्वाधर' : 'क्षैतिज'} फ्लिप करें';

  @override
  String get materialOriginalAspectRatioLabel => 'मूल';

  @override
  String get materialResetLabel => 'रीसेट';

  @override
  String get materialSquareAspectRatioLabel => 'वर्ग';

  @override
  String get saveLabel => 'सहेजें';
}
