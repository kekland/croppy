import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsTr extends CroppyLocalizations {
  CroppyLocalizationsTr() : super('tr');

  @override
  String get cancelLabel => 'İptal';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'SERBEST';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORİJİNAL';

  @override
  String get cupertinoResetLabel => 'SIFIRLA';

  @override
  String get cupertinoSquareAspectRatioLabel => 'KARE';

  @override
  String get doneLabel => 'Tamam';

  @override
  String get materialFreeformAspectRatioLabel => 'Serbest';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      '${direction == LocalizationDirection.vertical ? 'Dikey' : 'Yatay'} çevir';

  @override
  String get materialOriginalAspectRatioLabel => 'Orijinal';

  @override
  String get materialResetLabel => 'Sıfırla';

  @override
  String get materialSquareAspectRatioLabel => 'Kare';

  @override
  String get saveLabel => 'Kaydet';
}
