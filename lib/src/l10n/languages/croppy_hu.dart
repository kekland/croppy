import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsHu extends CroppyLocalizations {
  CroppyLocalizationsHu() : super('hu');

  @override
  String get cancelLabel => 'Mégse';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'SZABAD';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'EREDETI';

  @override
  String get cupertinoResetLabel => 'VISSZAÁLLÍTÁS';

  @override
  String get cupertinoSquareAspectRatioLabel => 'NÉGYZET';

  @override
  String get doneLabel => 'Kész';

  @override
  String get materialFreeformAspectRatioLabel => 'Szabad';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Tükrözés ${direction == LocalizationDirection.vertical ? 'függőlegesen' : 'vízszintesen'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Eredeti';

  @override
  String get materialResetLabel => 'Visszaállítás';

  @override
  String get materialSquareAspectRatioLabel => 'Négyzet';

  @override
  String get saveLabel => 'Mentés';
}
