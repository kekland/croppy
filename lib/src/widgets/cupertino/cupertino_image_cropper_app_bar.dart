import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:croppy/src/src.dart';

class CupertinoImageCropperAppBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  const CupertinoImageCropperAppBar({
    super.key,
    required this.controller,
  });

  final CroppableImageController controller;

  Widget _buildAppBarButtons(BuildContext context) {
    return Row(
      children: [
        if (controller.isTransformationEnabled(Transformation.mirror))
          CupertinoButton(
            onPressed: controller.onMirrorHorizontal,
            minSize: 44.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: CupertinoFlipHorizontalIcon(
              color: CupertinoTheme.of(context).primaryContrastingColor,
              size: 24.0,
            ),
          ),
        if (controller.isTransformationEnabled(Transformation.rotate))
          CupertinoButton(
            onPressed: controller.onRotateCCW,
            minSize: 44.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Icon(
              CupertinoIcons.rotate_left_fill,
              color: CupertinoTheme.of(context).primaryContrastingColor,
            ),
          ),
        const Spacer(),
        if (controller is CupertinoCroppableImageController &&
            (controller as CupertinoCroppableImageController)
                    .allowedAspectRatios
                    .length >
                1)
          ValueListenableBuilder(
            valueListenable: (controller as CupertinoCroppableImageController)
                .toolbarNotifier,
            builder: (context, toolbar, _) => CupertinoButton(
              onPressed: () {
                // ignore: no_leading_underscores_for_local_identifiers
                final _controller =
                    controller as CupertinoCroppableImageController;

                _controller.toggleToolbar(
                  CupertinoCroppableImageToolbar.aspectRatio,
                );
              },
              minSize: 44.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: CupertinoAspectRatioIcon(
                color: toolbar == CupertinoCroppableImageToolbar.aspectRatio
                    ? CupertinoTheme.of(context).primaryColor
                    : CupertinoTheme.of(context).primaryContrastingColor,
                size: 24.0,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = CroppyLocalizations.of(context)!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        top: true,
        child: SizedBox(
          height: preferredSize.height,
          child: Stack(
            children: [
              _buildAppBarButtons(context),
              Center(
                child: ValueListenableBuilder(
                  valueListenable: controller.canResetNotifier,
                  builder: (context, canReset, child) => AnimatedOpacity(
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 100),
                    opacity: canReset ? 1.0 : 0.0,
                    child: IgnorePointer(
                      ignoring: !canReset,
                      child: child,
                    ),
                  ),
                  child: CupertinoButton(
                    onPressed: controller.reset,
                    minSize: 44.0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      l10n.cupertinoResetLabel,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navActionTextStyle
                          .copyWith(fontSize: 14.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44.0);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}
