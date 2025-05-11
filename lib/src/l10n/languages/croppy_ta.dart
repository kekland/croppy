import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsTa extends CroppyLocalizations {
  CroppyLocalizationsTa() : super('ta');

  @override
  String get cancelLabel => 'ரத்துசெய்';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'இலவச';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'அசல்';

  @override
  String get cupertinoResetLabel => 'மீட்டமை';

  @override
  String get cupertinoSquareAspectRatioLabel => 'சதுரம்';

  @override
  String get doneLabel => 'முடிந்தது';

  @override
  String get materialFreeformAspectRatioLabel => 'இலவச';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      '${direction == LocalizationDirection.vertical ? 'செங்குத்தாக' : 'கிடைமட்டமாக'} திருப்பு';

  @override
  String get materialOriginalAspectRatioLabel => 'அசல்';

  @override
  String get materialResetLabel => 'மீட்டமை';

  @override
  String get materialSquareAspectRatioLabel => 'சதுரம்';

  @override
  String get saveLabel => 'சேமி';
}