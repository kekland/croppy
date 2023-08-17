# Localization

Thanks for helping to localize `croppy`!

The localization files are stored in `lib/src/l10n/languages`. Each language has its own file, named `croppy_${languageCode}.dart`. For example, the English localization file is `croppy_en.dart`.

The class name should be like `CroppyLocalizationsEn` (for English) - i.e. with the capitalized language code in the end.

The class should extend `CroppyLocalizations` and implement all the abstract methods. Some methods and strings are provided by default in `CroppyLocalizations` (e.g. the degree sign) - if there's a need, you can override them.

After a language is added, it should be added to the `supportedLanguages` list in `lib/src/l10n/croppy_localizations.dart`.