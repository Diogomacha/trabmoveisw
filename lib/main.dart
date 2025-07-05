import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/login_page.dart';
import 'views/cadastro_page.dart';
import 'views/produto_page.dart';
import 'views/produto_usuario_page.dart';
import 'views/cadastro_camisa_page.dart';
import 'views/produto_gerenciar_page.dart';
import 'views/perfil_page.dart';
import 'views/carrinho_page.dart';

import 'models/usuario.dart';
import 'controllers/carrinho_controller.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CarrinhoController(),
      child: FutebolApp(),
    ),
  );
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
      home: const LoginPage(),
      onGenerateRoute: (settings) {
        if (settings.name == '/perfil') {
          final usuario = settings.arguments as Usuario;
          return MaterialPageRoute(
            builder: (_) => PerfilPage(usuario: usuario),
          );
        }

        if (settings.name == '/produto_usuario') {
          final usuario = settings.arguments as Usuario;
          return MaterialPageRoute(
            builder: (_) => ProdutoUsuarioPage(usuario: usuario),
          );
        }

        final routes = <String, WidgetBuilder>{
          '/login': (context) => const LoginPage(),
          '/cadastro_usuario': (context) => const CadastroPage(),
          '/home': (context) => ProdutoPage(),
          '/cadastro': (context) => CadastroCamisaPage(),
          '/gerenciar': (context) => CamisaGerenciarPage(),
          '/carrinho': (context) => const CarrinhoPage(),
        };

        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }

        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Página não encontrada')),
          ),
        );
      },
    );
  }
}
