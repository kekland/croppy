import 'package:flutter/cupertino.dart';

/// A button that executes a future when tapped.
///
/// This widget is useful for executing a future when a button is tapped. The
/// button will be disabled while the future is executing.
class FutureButton extends StatefulWidget {
  const FutureButton({
    super.key,
    required this.onTap,
    required this.builder,
  });

  final Future<void> Function() onTap;
  final Widget Function(
    BuildContext context,
    Future<void> Function()? onTap,
  ) builder;

  @override
  State<FutureButton> createState() => _FutureButtonState();
}

class _FutureButtonState extends State<FutureButton> {
  bool _isWaiting = false;

  Future<void> _execute() async {
    setState(() => _isWaiting = true);

    try {
      await widget.onTap();
    } catch (e) {
      rethrow;
    } finally {
      if (context.mounted) {
        setState(() => _isWaiting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _isWaiting ? null : _execute,
    );
  }
}
