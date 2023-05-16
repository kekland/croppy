import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CupertinoImageCropperAppBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  const CupertinoImageCropperAppBar({super.key, required this.controller});

  final CroppableImageController controller;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        top: true,
        child: Row(
          children: [
            CupertinoButton(
              onPressed: () => Navigator.maybePop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: CupertinoColors.white),
              ),
            ),
            const Spacer(),
            CupertinoButton(
              onPressed: () async {
                final result = await controller.crop();
    
                if (context.mounted) {
                  Navigator.of(context).pop(result);
                }
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44.0);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}
