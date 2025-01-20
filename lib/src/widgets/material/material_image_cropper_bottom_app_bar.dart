import 'package:flutter/material.dart';

import 'package:croppy/src/src.dart';

class MaterialImageCropperBottomAppBar extends StatelessWidget {
  const MaterialImageCropperBottomAppBar({
    super.key,
    required this.controller,
    required this.shouldPopAfterCrop,
    this.showLoadingIndicatorOnSubmit = false,
  });

  final CroppableImageController controller;
  final bool shouldPopAfterCrop;
  final bool showLoadingIndicatorOnSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = CroppyLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: Divider.createBorderSide(context),
        ),
      ),
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 16.0,
        right: 16.0,
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        minimum: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            SizedBox(
              height: 40.0,
              child: TextButton(
                onPressed: () => Navigator.maybePop(context),
                child: Text(l10n.cancelLabel),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 40.0,
              child: FutureButton(
                onTap: () async {
                  CroppableImagePageAnimator.of(context)
                      ?.setHeroesEnabled(true);

                  final result = await controller.crop();

                  if (context.mounted && shouldPopAfterCrop) {
                    Navigator.of(context).pop(result);
                  }
                },
                builder: (context, onTap) {
                  final showActivityIndicator =
                      showLoadingIndicatorOnSubmit && onTap == null;

                  final child = AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    firstCurve: Curves.easeInOut,
                    secondCurve: Curves.easeInOut,
                    firstChild: const SizedBox.square(
                      dimension: 24.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                        strokeAlign:
                            CircularProgressIndicator.strokeAlignInside,
                      ),
                    ),
                    secondChild: Text(l10n.doneLabel),
                    crossFadeState: showActivityIndicator
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  );

                  return FilledButton(
                    onPressed: onTap,
                    child: child,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
