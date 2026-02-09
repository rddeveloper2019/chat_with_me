import 'package:chat_with_me/widgets/circle_avatar_with_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isActive;
  final bool isActivity;
  final String imageUrl;
  final double height;
  final void Function()? onTap;

  const ChatListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.isActivity,
    required this.imageUrl,
    this.height = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: height * 0.20,
      onTap: onTap,
      leading: CircleAvatarWithStatus(isActive: isActivity, imageUrl: imageUrl),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      subtitle: isActive
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitThreeBounce(color: Colors.white70, size: height * 0.10),
              ],
            )
          : Text(
              '$subtitle...',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }
}
