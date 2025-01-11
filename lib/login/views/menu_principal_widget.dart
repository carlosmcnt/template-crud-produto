import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_crud_produto/diversos/views/menu_lateral.dart';

class MenuPrincipalWidget extends ConsumerStatefulWidget {
  const MenuPrincipalWidget({super.key});

  @override
  ConsumerState<MenuPrincipalWidget> createState() {
    return MenuPrincipalWidgetState();
  }
}

class MenuPrincipalWidgetState extends ConsumerState<MenuPrincipalWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Menu Principal')),
      ),
      body: const Center(
        child: Text('Bem-vindo ao menu principal!'),
      ),
      drawer: const MenuLateralWidget(),
    );
  }
}
