import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_crud_produto/login/models/usuario.dart';

class DadosUsuario extends ConsumerStatefulWidget {
  const DadosUsuario({super.key, required this.usuario});

  final Usuario usuario;

  @override
  ConsumerState<DadosUsuario> createState() {
    return DadosUsuarioState();
  }
}

class DadosUsuarioState extends ConsumerState<DadosUsuario> {
  Usuario get usuario => widget.usuario;
  bool habilitarEdicao = false;

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
                    enabled: habilitarEdicao,
                    initialValue: usuario.nomeCompleto,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                    ),
                  ),
                  TextFormField(
                    enabled: habilitarEdicao,
                    initialValue: usuario.email,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                    ),
                  ),
                  TextFormField(
                    enabled: habilitarEdicao,
                    initialValue: usuario.telefone,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            habilitarEdicao = !habilitarEdicao;
                          });
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
