import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsVi extends CroppyLocalizations {
  CroppyLocalizationsVi() : super('vi');

  @override
  String get cancelLabel => 'Huỷ';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'TỰ DO';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'NGUYÊN BẢN';

  @override
  String get cupertinoResetLabel => 'KHÔI PHỤC';

  @override
  String get cupertinoSquareAspectRatioLabel => 'VUÔNG';

  @override
  String get doneLabel => 'Xong';

  @override
  String get materialFreeformAspectRatioLabel => 'Tự do';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) {
    return 'Xoay ${direction == LocalizationDirection.vertical ? 'dọc' : 'ngang'}';
  }

  @override
  String get materialOriginalAspectRatioLabel => 'Nguyên bản';

  @override
  String get materialResetLabel => 'Khôi phục';

  @override
  String get materialSquareAspectRatioLabel => 'Vuông';

  @override
  String get saveLabel => 'Xong';
}
