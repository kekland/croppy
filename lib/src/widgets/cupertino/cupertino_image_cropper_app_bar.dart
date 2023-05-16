import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => SafeArea(
          top: true,
          child: Stack(
            children: [
              Row(
                children: [
                  // TODO: Cupertino icons are not available in Flutter yet
                  CupertinoButton(
                    onPressed: controller.onMirrorHorizontal,
                    minSize: 44.0,
                    child: const Icon(
                      Icons.flip_rounded,
                      color: CupertinoColors.systemGrey2,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: controller.onRotateCCW,
                    minSize: 44.0,
                    child: const Icon(
                      Icons.rotate_90_degrees_ccw_rounded,
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
                child: AnimatedOpacity(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 100),
                  opacity: controller.canReset ? 1.0 : 0.0,
                  child: CupertinoButton(
                    onPressed: controller.reset,
                    child: Text(
                      'RESET',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navActionTextStyle,
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
