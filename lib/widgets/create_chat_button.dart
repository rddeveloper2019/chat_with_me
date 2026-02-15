import 'package:chat_with_me/providers/users_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateChatButton extends StatelessWidget {
  const CreateChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedUsers = Provider.of<UsersPageProvider>(context).selectedUsers;
    return selectedUsers.isEmpty
        ? empty()
        : GestureDetector(
            onTap: () {
              context.read<UsersPageProvider>().createChat();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.people_alt, color: Colors.white38),
            ),
          );
  }

  Widget empty() => Container();
}
