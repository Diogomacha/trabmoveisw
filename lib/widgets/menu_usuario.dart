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
      onTap: aoSelecionar,
      selectedItemColor: Colors.green[800],
      unselectedItemColor: Colors.grey[500],
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'Pedidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Carrinho',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.support_agent_outlined),
          label: 'Ajuda',
        ),
      ],
    );
  }
}
