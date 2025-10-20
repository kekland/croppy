import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoImageAspectRatioToolbar extends StatelessWidget {
  const CupertinoImageAspectRatioToolbar({
    super.key,
    required this.controller,
  });

  final AspectRatioMixin controller;

  CropAspectRatio? get _aspectRatio => controller.currentAspectRatio;
  bool get _isHorizontal => _aspectRatio != null && _aspectRatio!.isHorizontal;

  String _convertAspectRatioToString(
    BuildContext context,
    CropAspectRatio? aspectRatio,
  ) {
    final l10n = CroppyLocalizations.of(context)!;

    if (aspectRatio == null) {
      return l10n.cupertinoFreeformAspectRatioLabel;
    }

    final width = aspectRatio.width;
    final height = aspectRatio.height;

    final imageSize = controller.data.imageSize;

    if ((width == imageSize.width && height == imageSize.height) ||
        (width == imageSize.height && height == imageSize.width)) {
      return l10n.cupertinoOriginalAspectRatioLabel;
    }

    if (aspectRatio.isSquare) {
      return l10n.cupertinoSquareAspectRatioLabel;
    }

    return l10n.getAspectRatioLabel(width, height);
  }

  List<Widget> _buildAspectRatioChips(BuildContext context) {
    final aspectRatios = controller.allowedAspectRatios;

    final displayedAspectRatios = <CropAspectRatio?>[];
    final aspectRatioPairs = <(CropAspectRatio, CropAspectRatio)>[];

    for (final aspectRatio in aspectRatios) {
      if (aspectRatio == null) {
        displayedAspectRatios.add(aspectRatio);
        continue;
      }

      final complement = aspectRatio.complement;

      if (aspectRatio.width == 1 && aspectRatio.height == 1) {
        displayedAspectRatios.add(aspectRatio);
        continue;
      }

      if (!aspectRatios.contains(complement)) {
        displayedAspectRatios.add(aspectRatio);
        continue;
      }

      final pair = aspectRatio.isHorizontal
          ? (aspectRatio, complement)
          : (complement, aspectRatio);

      if (!aspectRatioPairs.contains(pair)) {
        aspectRatioPairs.add(pair);
      }
    }

    for (final pair in aspectRatioPairs) {
      displayedAspectRatios.add(
        _isHorizontal ? pair.$1 : pair.$2,
      );
    }

    return displayedAspectRatios
        .map(
          (aspectRatio) => _AspectRatioChipWidget(
            aspectRatio: _convertAspectRatioToString(context, aspectRatio),
            isSelected: aspectRatio == _aspectRatio,
            onTap: () {
              controller.currentAspectRatio = aspectRatio;
            },
          ),
        )
        .toList();
  }

  List<Widget> _buildOrientationWidgets(BuildContext context) {
    final aspectRatios = controller.allowedAspectRatios;

    final complement = _aspectRatio?.complement;
    final hasComplement = complement != null &&
        _aspectRatio != complement &&
        aspectRatios.contains(complement);

    return [
      _CupertinoOrientationWidget(
        isVertical: true,
        isSelected: hasComplement && !_isHorizontal,
        onTap: () {
          if (!hasComplement) return;

          controller.currentAspectRatio =
              _isHorizontal ? complement : _aspectRatio;
        },
      ),
      _CupertinoOrientationWidget(
        isVertical: false,
        isSelected: hasComplement && _isHorizontal,
        onTap: () {
          if (!hasComplement) return;

          controller.currentAspectRatio =
              _isHorizontal ? _aspectRatio : complement;
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.aspectRatioNotifier,
      builder: (context, _, __) => Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildOrientationWidgets(context),
          ),
          const SizedBox(height: 16.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _buildAspectRatioChips(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _CupertinoOrientationWidget extends StatelessWidget {
  const _CupertinoOrientationWidget({
    required this.isVertical,
    required this.isSelected,
    required this.onTap,
  });

  final bool isVertical;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      minSize: 40.0,
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: 40.0,
        height: 40.0,
        child: Center(
          child: Container(
            width: isVertical ? 20.0 : 32.0,
            height: isVertical ? 32.0 : 20.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              border: Border.all(
                color: CupertinoTheme.of(context).primaryColor.withOpacity(0.7),
              ),
              color: isSelected
                  ? CupertinoTheme.of(context).primaryColor
                  : CupertinoTheme.of(context).barBackgroundColor,
            ),
            child: isSelected
                ? Icon(
                    CupertinoIcons.checkmark_alt,
                    color: CupertinoTheme.of(context).barBackgroundColor,
                    size: 18.0,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _AspectRatioChipWidget extends StatelessWidget {
  const _AspectRatioChipWidget({
    required this.aspectRatio,
    required this.onTap,
    this.isSelected = false,
  });

  final String aspectRatio;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      minSize: 40.0,
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ),
      child: Container(
        height: 24.0,
        decoration: BoxDecoration(
          color:
              isSelected ? CupertinoTheme.of(context).primaryColor.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 2.0,
        ),
        alignment: Alignment.center,
        child: Text(
          aspectRatio,
          style: TextStyle(
            color: isSelected
                ? CupertinoTheme.of(context).primaryContrastingColor
                : CupertinoTheme.of(context).primaryColor,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
