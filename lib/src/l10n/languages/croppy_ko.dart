import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsKo extends CroppyLocalizations {
  CroppyLocalizationsKo() : super('ko');

  @override
  String get cancelLabel => '취소';

  @override
  String get cupertinoFreeformAspectRatioLabel => '자유형식';

  @override
  String get cupertinoOriginalAspectRatioLabel => '원본';

  @override
  String get cupertinoResetLabel => '초기화';

  @override
  String get cupertinoSquareAspectRatioLabel => '정사각형';

  @override
  String get doneLabel => '완료';

  @override
  String get materialFreeformAspectRatioLabel => '자유형식';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      '${direction == LocalizationDirection.vertical ? '수직' : '수평'} 뒤집기';

  @override
  String get materialOriginalAspectRatioLabel => '원본';

  @override
  String get materialResetLabel => '초기화';

  @override
  String get materialSquareAspectRatioLabel => '정사각형';

  @override
  String get saveLabel => '저장';
}
