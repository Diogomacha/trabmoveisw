import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagemPickerProduto extends StatefulWidget {
  final String? imagemPathInicial;
  final void Function(String? path) onImageSelected;

  const ImagemPickerProduto({
    Key? key,
    this.imagemPathInicial,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  State<ImagemPickerProduto> createState() => _ImagemPickerProdutoState();
}

class _ImagemPickerProdutoState extends State<ImagemPickerProduto> {
  String? _imagemPath;

  @override
  void initState() {
    super.initState();
    _imagemPath = widget.imagemPathInicial;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source, imageQuality: 85);

      if (pickedFile != null) {
        setState(() {
          _imagemPath = pickedFile.path;
        });
        widget.onImageSelected(_imagemPath);
      }
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tirar foto'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Escolher da galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPickerOptions,
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage:
            _imagemPath != null ? FileImage(File(_imagemPath!)) : null,
            child: _imagemPath == null
                ? const Icon(Icons.person_add_alt_1, size: 50)
                : null,
          ),
          const SizedBox(height: 10),
          const Text("Toque para adicionar imagem"),
        ],
      ),
    );
  }
}
