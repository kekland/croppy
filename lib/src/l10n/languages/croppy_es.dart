import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsEs extends CroppyLocalizations {
  CroppyLocalizationsEs() : super('es');

  @override
  String get cancelLabel => 'Cancelar';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'LIBRE';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINAL';

  @override
  String get cupertinoResetLabel => 'RESTABLECER';

  @override
  String get cupertinoSquareAspectRatioLabel => 'CUADRADO';

  @override
  String get doneLabel => 'Listo';

  @override
  String get materialFreeformAspectRatioLabel => 'Libre';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Voltear ${direction == LocalizationDirection.vertical ? 'verticalmente' : 'horizontalmente'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Original';

  @override
  String get materialResetLabel => 'Restablecer';

  @override
  String get materialSquareAspectRatioLabel => 'Cuadrado';

  @override
  String get saveLabel => 'Listo';
}

