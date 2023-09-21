import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsPt extends CroppyLocalizations {
  CroppyLocalizationsPt() : super('pt');

  @override
  String get cancelLabel => 'Cancelar';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'LIVRE';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINAL';

  @override
  String get cupertinoResetLabel => 'REINICIAR';

  @override
  String get cupertinoSquareAspectRatioLabel => 'QUADRADO';

  @override
  String get doneLabel => 'OK';

  @override
  String get materialFreeformAspectRatioLabel => 'Livre';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Virar ${direction == LocalizationDirection.vertical ? 'verticalmente' : 'horizontalmente'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Original';

  @override
  String get materialResetLabel => 'Reiniciar';

  @override
  String get materialSquareAspectRatioLabel => 'Quadrado';

  @override
  String get saveLabel => 'Salvar';
}
