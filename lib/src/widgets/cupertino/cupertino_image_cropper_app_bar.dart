import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoImageCropperAppBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  const CupertinoImageCropperAppBar({super.key, required this.controller});

  final CroppableImageController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Row(
        children: [
          CupertinoButton(
            onPressed: () {},
            child: const Text(
              'Cancel',
              style: TextStyle(color: CupertinoColors.white),
            ),
          ),
          const Spacer(),
          CupertinoButton(
            onPressed: controller.crop,
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44.0);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}
