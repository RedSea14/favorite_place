import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});
  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectImage;
  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 500,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectImage = File(pickedImage.path);
    });
    widget.onPickImage(_selectImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: ElevatedButton.icon(
        onPressed: () {
          _takePicture();
        },
        icon: const Icon(
          Icons.camera,
          color: Colors.white,
        ),
        label: Text(
          "Take a picture",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
    if (_selectImage != null) {
      content = Image.file(
        _selectImage!,
        fit: BoxFit.cover,
      );
    }
    return Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: content);
  }
}
