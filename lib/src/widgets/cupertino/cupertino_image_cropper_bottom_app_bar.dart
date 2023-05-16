import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoImageCropperBottomAppBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  const CupertinoImageCropperBottomAppBar({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final CroppableImageController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            onSubmit();
            final result = await controller.crop();

            if (context.mounted) {
              Navigator.of(context).pop(result);
            }
          },
          child: const Text('Done'),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44.0);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}
