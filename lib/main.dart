import 'package:flutter/material.dart';
import 'views/produto_page.dart';
import 'views/cadastro_camisa_page.dart';
import 'views/camisa_gerenciar_page.dart';

void main() {
  runApp(FutebolApp());
}

class FutebolApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPORTS+',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ProdutoPage(),
      routes: {
        '/home': (context) => ProdutoPage(),
        '/cadastro': (context) => CadastroCamisaPage(),
        '/gerenciar': (context) => CamisaGerenciarPage(),
      },
    );
  }
}
