import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CircleImagePicker extends StatefulWidget {
  const CircleImagePicker({
    super.key,
    this.imageFile,
    this.imageUrl,
    required this.onImagePicked,
    this.radius = 32,
    this.borderColor = const Color(0xE3945526),
    this.placeholderText,
    this.placeholderIcon = Icons.person,
  });

  final File? imageFile;
  final String? imageUrl;
  final ValueChanged<File> onImagePicked;
  final double radius;
  final Color borderColor;
  final String? placeholderText;
  final IconData placeholderIcon;

  @override
  State<CircleImagePicker> createState() => _CircleImagePickerState();
}

class _CircleImagePickerState extends State<CircleImagePicker> {
  final ImagePicker _picker = ImagePicker();
  File? _pickedFile;

  Future<void> _showPickerSheet() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('ক্যামেরা থেকে তুলুন'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('গ্যালারি থেকে বাছাই করুন'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (picked != null) {
      final file = File(picked.path);
      setState(() => _pickedFile = file);
      widget.onImagePicked(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final File? file = _pickedFile ?? widget.imageFile;

    ImageProvider? backgroundImage;
    if (file != null) {
      backgroundImage = FileImage(file);
    } else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      backgroundImage = NetworkImage(widget.imageUrl!);
    }

    return GestureDetector(
      onTap: _showPickerSheet,
      child: CircleAvatar(
        radius: widget.radius,
        backgroundColor: widget.borderColor.withOpacity(0.1),
        backgroundImage: backgroundImage,
        child: backgroundImage == null
            ? (widget.placeholderText != null
                ? Text(
                    widget.placeholderText!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.borderColor,
                      fontFamily: 'TiroBangla-Regular',
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(widget.placeholderIcon, color: widget.borderColor))
            : null,
      ),
    );
  }
}
