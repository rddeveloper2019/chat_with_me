import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: "");

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color(0xFF2A2A2A),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white54,
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          iconColor: Colors.white54,
          hintText: 'Search a user..',
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(8),
        ),
        onChanged: (value) {
          print('(**) => onChanged:  ${value}');
        },
      ),
    );
  }
}
