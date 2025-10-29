import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsKy extends CroppyLocalizations {
  CroppyLocalizationsKy() : super('ky');

  @override
  String get cancelLabel => 'Баш тартуу';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'ЭРКИН';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ТҮПНУСКА';

  @override
  String get cupertinoResetLabel => 'БАШТАЛГЫЧ АБАЛ';

  @override
  String get cupertinoSquareAspectRatioLabel => 'ТЕҢ ТАРАП';

  @override
  String get doneLabel => 'Даяр';

  @override
  String get materialFreeformAspectRatioLabel => 'Эркин';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      '${direction == LocalizationDirection.vertical ? 'Тик' : 'Жатык'} түрдө айлантуу';

  @override
  String get materialOriginalAspectRatioLabel => 'Түпнуска';

  @override
  String get materialResetLabel => 'Баштапкы абал';

  @override
  String get materialSquareAspectRatioLabel => 'Тең тарап';

  @override
  String get saveLabel => 'Сактоо';
}
