import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,

    required this.message,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;

  final Widget icon;
  final String message;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Palette.gradientColor[0],
      elevation: 4.0,
      child: IconTheme.merge(
        data: theme.accentIconTheme,
        child: IconButton(
          tooltip: message,
          onPressed: onPressed!,
          icon: icon,
        ),
      ),
    );
  }
}
