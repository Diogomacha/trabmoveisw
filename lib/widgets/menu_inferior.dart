import 'package:flutter/material.dart';

class MenuInferior extends StatelessWidget {
  final int indiceSelecionado;
  final Function(int) aoSelecionar;

  const MenuInferior({
    Key? key,
    required this.indiceSelecionado,
    required this.aoSelecionar,
  }) : super(key: key);

  void _navegarPeloIndice(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/cadastro');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/gerenciar');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: indiceSelecionado,
      onTap: (index) {
        aoSelecionar(index);
        _navegarPeloIndice(context, index);
      },
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey[500],
      backgroundColor: Colors.white,
      elevation: 10,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Novo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Gerenciar',
        ),
      ],
    );
  }
}
