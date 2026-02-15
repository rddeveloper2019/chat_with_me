import 'package:flutter/material.dart';

class CreateChatButton extends StatelessWidget {
  const CreateChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(Icons.people_alt, color: Colors.white38),
    );
  }

  Widget empty() => Container();
}
