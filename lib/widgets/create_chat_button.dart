import 'package:flutter/material.dart';

class CreateChatButton extends StatelessWidget {
  const CreateChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Icon(Icons.people_alt, color: Colors.white38),
      ),
    );
  }

  Widget empty() => Container();
}
