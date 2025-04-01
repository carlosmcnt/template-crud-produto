import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/empresa/views/dados_empresa.dart';
import 'package:template_crud_produto/menu/controllers/menu_lateral_controller.dart';
import 'package:template_crud_produto/menu/views/dados_usuario.dart';
import 'package:template_crud_produto/menu/views/empresa_favorita.dart';
import 'package:template_crud_produto/pedido/views/historico_pedido_page.dart';
import 'package:template_crud_produto/usuario/models/usuario.dart';
import 'package:template_crud_produto/usuario/services/usuario_service.dart';
import 'package:template_crud_produto/usuario/views/login_widget.dart';
import 'package:template_crud_produto/usuario/views/menu_principal_widget.dart';

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
            leading: const Icon(Icons.home),
            title: const Text("Início"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MenuPrincipalWidget(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Meus dados"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DadosUsuario(
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
                  leading: const Icon(Icons.store),
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
            leading: const Icon(Icons.list_alt),
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
            leading: const Icon(Icons.favorite),
            title: const Text("Empresas favoritas"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const EmpresaFavorita(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
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
