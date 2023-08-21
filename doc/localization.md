# Localization

Thanks for helping to localize `croppy`!

The localization files are stored in `lib/src/l10n/languages`. Each language has its own file, named `croppy_${languageCode}.dart`. For example, the English localization file is `croppy_en.dart`.

The class name should be like `CroppyLocalizationsEn` (for English) - i.e. with the capitalized language code in the end.

The class should extend `CroppyLocalizations` and implement all the abstract methods. Some methods and strings are provided by default in `CroppyLocalizations` (e.g. the degree sign) - if there's a need, you can override them.

After a language is added, it should be added to the `supportedLanguages` list in `lib/src/l10n/croppy_localizations.dart`.

## Overriding localizations

To override the default `CroppyLocalizations`, create a new `LocalizationsDelegate<CroppyLocalizations>`:

```dart
import 'package:croppy/croppy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyCroppyLocalizationsDelegate
    extends LocalizationsDelegate<CroppyLocalizations> {
  @override
  bool isSupported(Locale locale) =>
      CroppyLocalizations.supportedLocales.contains(locale);

  @override
  Future<CroppyLocalizations> load(Locale locale) {
    if (locale.languageCode == 'en') {
      return SynchronousFuture(CroppyLocalizationsPirateEn());
    }

    return SynchronousFuture(lookupCroppyLocalizations(locale));
  }

  @override
  bool shouldReload(MyCroppyLocalizationsDelegate old) => false;
}

/// The translations for English (`en`) - for pirates cruising on a ship.
class CroppyLocalizationsPirateEn extends CroppyLocalizations {
  CroppyLocalizationsPirateEn() : super('en');
  
  ...
}
```

See `example/lib/localization_override_example.dart` for a full example.