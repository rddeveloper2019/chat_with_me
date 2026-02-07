import 'package:flutter/material.dart';

class CircleAvatarWithStatus extends StatelessWidget {
  final bool isActive;
  final double dotSize;
  final String imageUrl;

  const CircleAvatarWithStatus({
    super.key,
    required this.isActive,
    required this.imageUrl,
    this.dotSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(dotSize / 2),
            ),
          ),
        ),
      ],
    );
  }
}
