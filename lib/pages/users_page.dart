import 'package:chat_with_me/widgets/users_list.dart';
import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/providers/users_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (context) =>
              UsersPageProvider(auth: context.read<AuthProvider>()),
        ),
      ],
      child: UsersList(),
    );
  }
}
