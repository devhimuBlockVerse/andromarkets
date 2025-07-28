import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const CircularIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double buttonSize = screenWidth * 0.10;
    final double iconSize = buttonSize * 0.7;

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
