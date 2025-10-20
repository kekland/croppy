import 'package:flutter/cupertino.dart';

import 'package:croppy/src/src.dart';

class CupertinoImageCropperBottomAppBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  const CupertinoImageCropperBottomAppBar({
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
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    return Row(
      children: [
        CupertinoButton(
          onPressed: () => Navigator.maybePop(context),
          padding: const EdgeInsets.only(
            left: 4.0,
            right: 16.0,
            top: 16.0,
            bottom: 16.0,
          ),
          child: Text(
            l10n.cancelLabel,
            style: TextStyle(color: primaryColor),
          ),
        ),
        const Spacer(),
        FutureButton(
          onTap: () async {
            CroppableImagePageAnimator.of(context)?.setHeroesEnabled(true);

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
              firstChild: const CupertinoActivityIndicator(),
              secondChild: Text(
                l10n.doneLabel,
                style: TextStyle(
                  color: onTap != null
                      ? primaryColor
                      : primaryColor.withOpacity(0.5),
                ),
              ),
              crossFadeState: showActivityIndicator
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            );

            return CupertinoButton(
              onPressed: onTap,
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 4.0,
                top: 16.0,
                bottom: 16.0,
              ),
              child: child,
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44.0);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}
