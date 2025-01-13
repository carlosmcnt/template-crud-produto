import 'package:br_validators/br_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_crud_produto/usuario/models/usuario.dart';
import 'package:template_crud_produto/usuario/views/menu_principal_widget.dart';
import 'package:template_crud_produto/menu/controllers/dados_usuario_controller.dart';

class DadosUsuario extends ConsumerStatefulWidget {
  const DadosUsuario({super.key, required this.usuario});

  final Usuario usuario;

  @override
  ConsumerState<DadosUsuario> createState() {
    return DadosUsuarioState();
  }
}

class DadosUsuarioState extends ConsumerState<DadosUsuario> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _cpfController;
  late TextEditingController _telefoneController;
  Usuario get usuario => widget.usuario;
  bool habilitarEdicao = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: usuario.nomeCompleto);
    _emailController = TextEditingController(text: usuario.email);
    _cpfController = TextEditingController(text: usuario.cpf);
    _telefoneController = TextEditingController(text: usuario.telefone);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  AlertDialog dialogoConfirmacaoAlteracao(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Alterar Dados'),
      content: const Text('Deseja realmente confirmar as alterações?'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Usuario novoUsuario = usuario.copyWith(
              nomeCompleto: _nomeController.text,
              telefone: _telefoneController.text,
            );

            await ref
                .read(dadosUsuarioControllerProvider(novoUsuario).notifier)
                .atualizarUsuario(novoUsuario);

            if (!context.mounted) return;

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MenuPrincipalWidget(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Dados do Usuário')),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    enabled: habilitarEdicao,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Tooltip(
                    message: 'E-mail não pode ser alterado',
                    child: TextFormField(
                      controller: _emailController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Tooltip(
                    message: 'CPF não pode ser alterado',
                    child: TextFormField(
                      controller: _cpfController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'CPF',
                      ),
                      inputFormatters: [
                        BRMasks.cpf,
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _telefoneController,
                    enabled: habilitarEdicao,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                    ),
                    inputFormatters: [
                      BRMasks.mobilePhone,
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            habilitarEdicao = !habilitarEdicao;
                          });

                          if (!habilitarEdicao) {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  dialogoConfirmacaoAlteracao(context, ref),
                            );
                          }
                        },
                        child: Text(habilitarEdicao ? 'Salvar' : 'Editar'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              habilitarEdicao = false;
                            });
                          },
                          child: const Text('Cancelar')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
