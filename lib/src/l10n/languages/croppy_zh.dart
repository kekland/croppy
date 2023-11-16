import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsZh extends CroppyLocalizations {
  CroppyLocalizationsZh() : super('zh');

  @override
  String get cancelLabel => '取消';

  @override
  String get cupertinoFreeformAspectRatioLabel => '自由';

  @override
  String get cupertinoOriginalAspectRatioLabel => '原始';

  @override
  String get cupertinoResetLabel => '重置';

  @override
  String get cupertinoSquareAspectRatioLabel => '正方形';

  @override
  String get doneLabel => '完成';

  @override
  String get materialFreeformAspectRatioLabel => '自由';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      '转换到${direction == LocalizationDirection.vertical ? '竖向' : '横向'}';

  @override
  String get materialOriginalAspectRatioLabel => '原始';

  @override
  String get materialResetLabel => '重置';

  @override
  String get materialSquareAspectRatioLabel => '正方形';

  @override
  String get saveLabel => '保存';
}
