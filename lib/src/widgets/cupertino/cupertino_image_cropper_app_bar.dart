import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CupertinoImageCropperAppBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  const CupertinoImageCropperAppBar({
    super.key,
    required this.controller,
  });

  final CroppableImageController controller;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        top: true,
        child: SizedBox(
          height: preferredSize.height,
          child: Stack(
            children: [
              Row(
                children: [
                  CupertinoButton(
                    onPressed: controller.onMirrorHorizontal,
                    minSize: 44.0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    child: const CupertinoFlipHorizontalIcon(
                      color: CupertinoColors.systemGrey2,
                      size: 24.0,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: controller.onRotateCCW,
                    minSize: 44.0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    child: const Icon(
                      CupertinoIcons.rotate_left_fill,
                      color: CupertinoColors.systemGrey2,
                    ),
                  ),
                  const Spacer(),
                  // CupertinoButton(
                  //   onPressed: () {},
                  //   minSize: 44.0,
                  //   child: const Icon(
                  //     Icons.aspect_ratio_rounded,
                  //     color: CupertinoColors.systemGrey2,
                  //   ),
                  // ),
                ],
              ),
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
                      'RESET',
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
