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
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        aoSelecionar(index);
        _navegarPeloIndice(context, index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Cadastrar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build),
          label: 'Gerenciar',
        ),
      ],
    );
  }
}
