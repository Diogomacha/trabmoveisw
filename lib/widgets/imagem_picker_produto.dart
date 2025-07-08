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
            if (_imagemPath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remover imagem'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _imagemPath = null;
                  });
                  widget.onImageSelected(null);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  )
                ],
                border: Border.all(color: Colors.green.shade200, width: 2),
              ),
              child: CircleAvatar(
                backgroundImage:
                _imagemPath != null ? FileImage(File(_imagemPath!)) : null,
                backgroundColor: Colors.grey[200],
                child: _imagemPath == null
                    ? const Icon(Icons.image_outlined, size: 50, color: Colors.grey)
                    : null,
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap: _showPickerOptions,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: _showPickerOptions,
          child: const Text(
            "Selecionar imagem do produto",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
