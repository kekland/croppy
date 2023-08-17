import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsRu extends CroppyLocalizations {
  CroppyLocalizationsRu() : super('ru');

  @override
  String get cancelLabel => 'Отмена';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'ПРОИЗВОЛЬНЫЙ';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ОРИГИНАЛ';

  @override
  String get cupertinoResetLabel => 'СБРОСИТЬ';

  @override
  String get cupertinoSquareAspectRatioLabel => 'КВАДРАТ';

  @override
  String get doneLabel => 'Готово';

  @override
  String get materialFreeformAspectRatioLabel => 'Произвольный';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Перевернуть ${direction == LocalizationDirection.vertical ? 'вертикально' : 'горизонтально'}}';

  @override
  String get materialOriginalAspectRatioLabel => 'Оригинал';

  @override
  String get materialResetLabel => 'Сбросить';

  @override
  String get materialSquareAspectRatioLabel => 'Квадрат';

  @override
  String get saveLabel => 'Сохранить';
}
