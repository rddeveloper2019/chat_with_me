import 'package:chat_with_me/models/chat_user.dart';
import 'package:chat_with_me/widgets/circle_avatar_with_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserListTile extends StatelessWidget {
  final ChatUser user;
  final bool isSelected;
  final void Function()? onTap;

  const UserListTile({
    super.key,
    required this.user,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final lastActiveDate = timeago.format(
      user.lastActiveDate.toDate(),
      locale: 'ru',
    );

    return ListTile(
      minVerticalPadding: height * 0.02,
      onTap: () {},
      leading: CircleAvatarWithStatus(
        isActive: user.wasRecentlyActive(),
        imageUrl: user.imageUrl,
      ),
      title: Text(
        user.name,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      subtitle: user.wasRecentlyActive()
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitThreeBounce(color: Colors.white70, size: height * 0.01),
              ],
            )
          : Text(
              lastActiveDate,
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }
}
