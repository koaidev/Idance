import 'package:flutter/material.dart';

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      elevation: 4.0,
      child: IconButton(
        iconSize: 56,
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.secondary,
      ),
    );
  }
}
