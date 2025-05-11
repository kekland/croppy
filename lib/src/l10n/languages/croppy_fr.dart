import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsFr extends CroppyLocalizations {
  CroppyLocalizationsFr() : super('fr');

  @override
  String get cancelLabel => 'Annuler';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'LIBRE';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORIGINAL';

  @override
  String get cupertinoResetLabel => 'RÉINITIALISER';

  @override
  String get cupertinoSquareAspectRatioLabel => 'CARRÉ';

  @override
  String get doneLabel => 'Terminé';

  @override
  String get materialFreeformAspectRatioLabel => 'Libre';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Retourner ${direction == LocalizationDirection.vertical ? 'verticalement' : 'horizontalement'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Original';

  @override
  String get materialResetLabel => 'Réinitialiser';

  @override
  String get materialSquareAspectRatioLabel => 'Carré';

  @override
  String get saveLabel => 'Enregistrer';
}
