import 'package:chat_with_me/services/media_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final PlatformFile? image;
  final double size;

  final void Function(PlatformFile? value) onSelect;

  const ProfileImage({
    super.key,
    required this.size,
    required this.image,
    required this.onSelect,
    this.imageUrl = 'https://picsum.photos/300/300',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GetIt.I<MediaService>().pickImageFromLibrary().then(onSelect);
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          image: DecorationImage(
            image: image != null
                ? AssetImage(image!.path!)
                : NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          color: Colors.black,
        ),
      ),
    );
  }
}
