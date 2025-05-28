import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsJa extends CroppyLocalizations {
  CroppyLocalizationsJa() : super('ja');

  @override
  String get cancelLabel => 'キャンセル';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'フリー';

  @override
  String get cupertinoOriginalAspectRatioLabel => '元のサイズ';

  @override
  String get cupertinoResetLabel => 'リセット';

  @override
  String get cupertinoSquareAspectRatioLabel => '正方形';

  @override
  String get doneLabel => '完了';

  @override
  String get materialFreeformAspectRatioLabel => 'フリー';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      '${direction == LocalizationDirection.vertical ? '垂直' : '水平'}に反転';

  @override
  String get materialOriginalAspectRatioLabel => '元のサイズ';

  @override
  String get materialResetLabel => 'リセット';

  @override
  String get materialSquareAspectRatioLabel => '正方形';

  @override
  String get saveLabel => '保存';
}
