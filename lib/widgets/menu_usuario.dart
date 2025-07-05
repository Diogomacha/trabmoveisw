import 'package:flutter/material.dart';

class MenuUsuario extends StatelessWidget {
  final int indiceSelecionado;
  final Function(int) aoSelecionar;

  const MenuUsuario({
    Key? key,
    required this.indiceSelecionado,
    required this.aoSelecionar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: indiceSelecionado,
      selectedItemColor: Colors.green[800],
      unselectedItemColor: Colors.grey,
      onTap: aoSelecionar,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Pedidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Carrinho',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.support_agent),
          label: 'Fale Conosco',
        ),
      ],
    );
  }
}
