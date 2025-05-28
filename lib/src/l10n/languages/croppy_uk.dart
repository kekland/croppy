import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsUk extends CroppyLocalizations {
  CroppyLocalizationsUk() : super('uk');

  @override
  String get cancelLabel => 'Скасувати';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'ДОВІЛЬНО';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ОРИГІНАЛ';

  @override
  String get cupertinoResetLabel => 'СКИНУТИ';

  @override
  String get cupertinoSquareAspectRatioLabel => 'КВАДРАТ';

  @override
  String get doneLabel => 'Готово';

  @override
  String get materialFreeformAspectRatioLabel => 'Довільно';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Відобразити ${direction == LocalizationDirection.vertical ? 'вертикально' : 'горизонтально'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Оригінал';

  @override
  String get materialResetLabel => 'Скинути';

  @override
  String get materialSquareAspectRatioLabel => 'Квадрат';

  @override
  String get saveLabel => 'Зберегти';
}
