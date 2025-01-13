import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_crud_produto/menu/views/menu_lateral.dart';
import 'package:template_crud_produto/utils/tema.dart';

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
      appBar: Tema.appBar(),
      body: const Center(
        child: Text('Bem-vindo ao menu principal!'),
      ),
      drawer: const MenuLateralWidget(),
    );
  }
}
