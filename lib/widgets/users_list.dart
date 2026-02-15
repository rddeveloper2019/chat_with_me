import 'package:chat_with_me/providers/users_page_provider.dart';
import 'package:chat_with_me/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key});

  @override
  Widget build(BuildContext context) {
    final users = context.watch<UsersPageProvider>().users;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          final user = users[index];
          final isSelected = context
              .watch<UsersPageProvider>()
              .selectedUsers
              .contains(user);
          print('(**) => isSelected:  ${isSelected}');
          return UserListTile(
            user: user,
            isSelected: isSelected,
            onTap: () {
              context.read<UsersPageProvider>().updatesSelectedUsers(user);
            },
          );
        },
      ),
    );
  }
}
