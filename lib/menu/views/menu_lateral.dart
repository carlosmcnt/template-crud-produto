import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_crud_produto/menu/views/dados_usuario.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/empresa/services/empresa_service.dart';
import 'package:template_crud_produto/empresa/views/empresa_edit_widget.dart';
import 'package:template_crud_produto/usuario/models/usuario.dart';
import 'package:template_crud_produto/usuario/services/usuario_service.dart';
import 'package:template_crud_produto/usuario/views/login_widget.dart';
import 'package:template_crud_produto/usuario/views/menu_principal_widget.dart';
import 'package:template_crud_produto/produto/views/produto_list_widget.dart';

class MenuLateralWidget extends ConsumerStatefulWidget {
  const MenuLateralWidget({super.key});

  @override
  ConsumerState<MenuLateralWidget> createState() {
    return MenuLateralWidgetState();
  }
}

class MenuLateralWidgetState extends ConsumerState<MenuLateralWidget> {
  Usuario? usuario;

  @override
  void initState() {
    super.initState();
    _initializeUsuario();
  }

  Future<void> _initializeUsuario() async {
    try {
      final user = await ref.read(usuarioServiceProvider).obterUsuarioLogado();
      if (user != null) {
        setState(() {
          usuario = user;
        });
      }
    } catch (e) {
      throw Exception('Erro ao obter usuário logado: $e');
    }
  }

  Future<Empresa?> pesquisarEmpresaPorUsuario() async {
    Empresa? empresa = await ref
        .read(empresaServiceProvider)
        .obterEmpresaPorUsuarioId(usuario!.id!);
    return empresa;
  }

  @override
  Widget build(BuildContext context) {
    return menuLateral(context);
  }

  Drawer menuLateral(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(usuario?.nomeCompleto ?? ''),
            accountEmail: Text(usuario?.email ?? ''),
            currentAccountPictureSize: const Size.square(64),
            currentAccountPicture: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              child: Text(usuario?.nomeCompleto.substring(0, 1) ?? '',
                  style: const TextStyle(fontSize: 30.0, color: Colors.blue)),
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
                          email: usuario!.email,
                          cpf: usuario!.cpf,
                          telefone: usuario!.telefone,
                          dataCadastro: usuario!.dataCadastro,
                          dataUltimaAlteracao: usuario!.dataUltimaAlteracao,
                        ),
                      )));
            },
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text("Perfil Empresa"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return verificarEmpresaExistente(context, ref);
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text("Histórico de pedidos"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text("Empresas favoritas"),
            onTap: () {
              Navigator.pop(context);
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

  Widget verificarEmpresaExistente(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Empresa?>(
      future: pesquisarEmpresaPorUsuario(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Erro ao verificar existência de empresa');
        } else {
          if (snapshot.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      ProdutoListPage(empresa: snapshot.data!),
                ),
              );
            });
            return const SizedBox.shrink();
          } else {
            return dialogoCriacaoEmpresa(context, ref);
          }
        }
      },
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

  AlertDialog dialogoCriacaoEmpresa(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Criação de Empresa'),
      content: const Text(
          'Você ainda não possui um perfil de empresa. Deseja criar um agora?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => EmpresaEditPage(
                  empresa: Empresa(
                    nomeFantasia: '',
                    usuarioId: usuario!.id!,
                    chavePix: '',
                    descricao: '',
                    logomarca: '',
                    locaisEntrega: [],
                    dataCadastro: Timestamp.now(),
                    dataUltimaAlteracao: Timestamp.now(),
                  ),
                ),
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
