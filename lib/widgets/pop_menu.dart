import 'package:flutter/material.dart';

class PopUpMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;

  const PopUpMenuTile(
      {Key? key,
      required this.icon,
      required this.title,
      this.isActive = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(icon,
            color: isActive
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).primaryColor),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headline4?.copyWith(
              color: isActive
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}
