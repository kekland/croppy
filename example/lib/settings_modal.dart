import 'package:croppy/croppy.dart';
import 'package:flutter/material.dart';

class CropSettings {
  CropSettings({
    required this.cropShapeFn,
    required this.enabledTransformations,
    required this.forcedAspectRatio,
    this.locale = const Locale('en'),
  });

  CropSettings.initial()
      : this(
          cropShapeFn: aabbCropShapeFn,
          enabledTransformations: Transformation.values,
          forcedAspectRatio: null,
        );

  final CropShapeFn cropShapeFn;
  final List<Transformation> enabledTransformations;
  final CropAspectRatio? forcedAspectRatio;
  final Locale locale;

  CropSettings copyWith({
    CropShapeFn? cropShapeFn,
    List<Transformation>? enabledTransformations,
    CropAspectRatio? forcedAspectRatio,
    Locale? locale,
  }) {
    return CropSettings(
      cropShapeFn: cropShapeFn ?? this.cropShapeFn,
      enabledTransformations:
          enabledTransformations ?? this.enabledTransformations,
      forcedAspectRatio: forcedAspectRatio ?? this.forcedAspectRatio,
      locale: locale ?? this.locale,
    );
  }

  CropSettings copyWithNoForcedAspectRatio() {
    return CropSettings(
      cropShapeFn: cropShapeFn,
      enabledTransformations: enabledTransformations,
      forcedAspectRatio: null,
      locale: locale,
    );
  }
}

Future<CropSettings> showCropSettingsModal({
  required BuildContext context,
  required CropSettings initialSettings,
}) async {
  final settings = await showModalBottomSheet<CropSettings>(
    context: context,
    builder: (context) {
      return SettingsModalWidget(
        initialSettings: initialSettings,
      );
    },
  );

  return settings ?? initialSettings;
}

const _forceableAspectRatios = [
  CropAspectRatio(width: 1, height: 1),
  CropAspectRatio(width: 16, height: 9),
  CropAspectRatio(width: 4, height: 3),
  CropAspectRatio(width: 3, height: 2),
];

class SettingsModalWidget extends StatefulWidget {
  const SettingsModalWidget({super.key, required this.initialSettings});

  final CropSettings initialSettings;

  @override
  State<SettingsModalWidget> createState() => _SettingsModalWidgetState();
}

class _SettingsModalWidgetState extends State<SettingsModalWidget> {
  late CropSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_settings);
        return false;
      },
      child: SingleChildScrollView(
        child: ListBody(
          children: [
            const ListTile(
              enabled: false,
              title: Text('Crop shape'),
            ),
            RadioListTile(
              title: const Text('Rectangle'),
              value: aabbCropShapeFn,
              groupValue: _settings.cropShapeFn,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(
                    cropShapeFn: value as CropShapeFn,
                  );
                });
              },
            ),
            RadioListTile(
              title: const Text('Ellipse'),
              value: ellipseCropShapeFn,
              groupValue: _settings.cropShapeFn,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(
                    cropShapeFn: value as CropShapeFn,
                  );
                });
              },
            ),
            RadioListTile(
              title: const Text('Star'),
              value: starCropShapeFn,
              groupValue: _settings.cropShapeFn,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(
                    cropShapeFn: value as CropShapeFn,
                  );
                });
              },
            ),
            const ListTile(
              enabled: false,
              title: Text('Locale'),
            ),
            ...CroppyLocalizations.supportedLocales.map(
              (v) => RadioListTile(
                title: Text(v.toString()),
                value: v,
                groupValue: _settings.locale,
                onChanged: (value) {
                  setState(() {
                    _settings = _settings.copyWith(locale: value as Locale);
                  });
                },
              ),
            ),
            const ListTile(
              enabled: false,
              title: Text('Enabled transformations'),
            ),
            ...Transformation.values.map(
              (v) => CheckboxListTile(
                title: Text(v.toString()),
                value: _settings.enabledTransformations.contains(v),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _settings = _settings.copyWith(
                        enabledTransformations: [
                          ..._settings.enabledTransformations,
                          v,
                        ],
                      );
                    } else {
                      _settings = _settings.copyWith(
                        enabledTransformations: _settings.enabledTransformations
                            .where((e) => e != v)
                            .toList(),
                      );
                    }
                  });
                },
              ),
            ),
            const ListTile(
              enabled: false,
              title: Text('Forced aspect ratio'),
            ),
            RadioListTile(
              title: const Text('None'),
              value: null,
              groupValue: _settings.forcedAspectRatio,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWithNoForcedAspectRatio();
                });
              },
            ),
            ..._forceableAspectRatios.map(
              (v) => RadioListTile(
                title: Text('${v.width}:${v.height}'),
                value: v,
                groupValue: _settings.forcedAspectRatio,
                onChanged: (value) {
                  setState(() {
                    _settings = _settings.copyWith(forcedAspectRatio: value);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
