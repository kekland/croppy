import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class MaterialImageCropperBottomAppBar extends StatelessWidget {
  const MaterialImageCropperBottomAppBar({
    super.key,
    required this.controller,
  });

  final CroppableImageController controller;

  @override
  Widget build(BuildContext context) {
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
                child: const Text('Cancel'),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 40.0,
              child: FilledButton(
                onPressed: () async {
                  context
                      .findAncestorStateOfType<
                          CroppableImagePageAnimatorState>()
                      ?.setHeroesEnabled(true);

                  final result = await controller.crop();

                  if (context.mounted) {
                    Navigator.of(context).pop(result);
                  }
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
