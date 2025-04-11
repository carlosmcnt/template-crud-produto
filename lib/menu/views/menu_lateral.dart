import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/empresa/views/dados_empresa.dart';
import 'package:template_crud_produto/menu/controllers/menu_lateral_controller.dart';
import 'package:template_crud_produto/menu/views/configuracao_page.dart';
import 'package:template_crud_produto/menu/views/empresa_favorita_page.dart';
import 'package:template_crud_produto/pedido/views/carrinho_page.dart';
import 'package:template_crud_produto/pedido/views/historico_pedido_page.dart';
import 'package:template_crud_produto/usuario/models/usuario.dart';
import 'package:template_crud_produto/usuario/services/usuario_service.dart';
import 'package:template_crud_produto/usuario/views/login_page.dart';
import 'package:template_crud_produto/usuario/views/menu_principal_page.dart';

class MenuLateralWidget extends ConsumerStatefulWidget {
  const MenuLateralWidget({super.key});

  @override
  ConsumerState<MenuLateralWidget> createState() {
    return MenuLateralWidgetState();
  }
}

class MenuLateralWidgetState extends ConsumerState<MenuLateralWidget> {
  @override
  Widget build(BuildContext context) {
    final usuarioLogado = ref.watch(menuLateralControllerProvider);

    return usuarioLogado.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Erro ao carregar usuário: $error'),
      data: (usuario) {
        return menuLateral(context, usuario);
      },
    );
  }

  Drawer menuLateral(BuildContext context, Usuario? usuario) {
    final empresa =
        ref.read(menuLateralControllerProvider.notifier).obterEmpresaLogada();
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor,
            ),
            accountName: SizedBox(
              child: Text(
                usuario?.nomeCompleto ?? '',
                style: const TextStyle(fontSize: 18, color: Colors.white),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            accountEmail: Text(usuario?.email ?? '',
                style: const TextStyle(fontSize: 15, color: Colors.white)),
            currentAccountPictureSize: const Size.square(60),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).focusColor,
              child: Text(usuario?.nomeCompleto.substring(0, 1) ?? '',
                  style: const TextStyle(fontSize: 30, color: Colors.white)),
            ),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.house),
            title: const Text("Início"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MenuPrincipalPage(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.gear),
            title: const Text("Minhas configurações"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ConfiguracaoPage(
                        usuario: Usuario(
                          nomeCompleto: usuario!.nomeCompleto,
                          email: usuario.email,
                          cpf: usuario.cpf,
                          telefone: usuario.telefone,
                          dataCadastro: usuario.dataCadastro,
                          dataUltimaAlteracao: usuario.dataUltimaAlteracao,
                        ),
                      )));
            },
          ),
          FutureBuilder<Empresa?>(
            future: empresa,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar informação: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const SizedBox.shrink();
              } else {
                return ListTile(
                  leading: const Icon(FontAwesomeIcons.building),
                  title: const Text("Perfil Empresa"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DadosEmpresaPage(empresa: snapshot.data!),
                    ));
                  },
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.clockRotateLeft),
            title: const Text("Histórico de pedidos"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      const HistoricoPedidoPage(isHistoricoEmpresa: false),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.heartPulse),
            title: const Text("Empresas favoritas"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const EmpresaFavoritaPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.cartShopping),
            title: const Text("Carrinho"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CarrinhoPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.rightFromBracket),
            title: const Text("Sair"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return dialogoConfirmacaoSaida(context, ref);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  AlertDialog dialogoConfirmacaoSaida(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Saída'),
      content: const Text('Deseja realmente sair?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            ref.read(usuarioServiceProvider).logout();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          child: const Text('Sim'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Não'),
        ),
      ],
    );
  }
}
