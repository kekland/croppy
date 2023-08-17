import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsKk extends CroppyLocalizations {
  CroppyLocalizationsKk() : super('kk');

  @override
  String get cancelLabel => 'Бас тарту';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'ЕРКІН';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ТҮПНҰСҚА';

  @override
  String get cupertinoResetLabel => 'БАСТАПҚЫ КҮЙ';

  @override
  String get cupertinoSquareAspectRatioLabel => 'ШАРШЫ';

  @override
  String get doneLabel => 'Дайын';

  @override
  String get materialFreeformAspectRatioLabel => 'Еркін';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      '${direction == LocalizationDirection.vertical ? 'Тігінен' : 'Көлденең'} аудару';

  @override
  String get materialOriginalAspectRatioLabel => 'Түпнұсқа';

  @override
  String get materialResetLabel => 'Бастапқы күй';

  @override
  String get materialSquareAspectRatioLabel => 'Шаршы';

  @override
  String get saveLabel => 'Сақтау';
}
