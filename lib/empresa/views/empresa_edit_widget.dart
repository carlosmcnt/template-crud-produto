import 'package:br_validators/br_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/empresa/services/empresa_service.dart';
import 'package:template_crud_produto/usuario/services/usuario_service.dart';
import 'package:template_crud_produto/utils/validador.dart';

class EmpresaEditPage extends ConsumerStatefulWidget {
  final Empresa empresa;

  const EmpresaEditPage({super.key, required this.empresa});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return EmpresaEditPageState();
  }
}

class EmpresaEditPageState extends ConsumerState<EmpresaEditPage> {
  late TextEditingController _nomeFantasiaController;
  late TextEditingController _chavePixController;
  late TextEditingController _descricaoController;
  late TextEditingController _locaisEntregaController;
  List<String> _locaisEntrega = [];
  Validador validador = Validador();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var tipoChavePix = '';
  bool checkboxMarcado = false;

  Empresa get empresa => widget.empresa;

  @override
  void initState() {
    super.initState();
    _nomeFantasiaController = TextEditingController(text: empresa.nomeFantasia);
    _chavePixController = TextEditingController(text: empresa.chavePix);
    _descricaoController = TextEditingController(text: empresa.descricao);
    _locaisEntregaController = TextEditingController();
    _locaisEntrega = List<String>.from(empresa.locaisEntrega);
  }

  @override
  void dispose() {
    _nomeFantasiaController.dispose();
    _chavePixController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child:
                Text(empresa.id == null ? 'Criar Empresa' : 'Alterar Empresa')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nomeFantasiaController,
                  maxLength: 40,
                  decoration: InputDecoration(
                    labelText: 'Nome Fantasia:',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.business),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome Fantasia é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField(
                  items: validador.listaTiposChavesPix(),
                  value: tipoChavePix,
                  onTap: () {
                    _chavePixController.clear();
                    checkboxMarcado = false;
                  },
                  decoration: InputDecoration(
                    labelText: 'Tipo da chave Pix:',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.qr_code),
                  ),
                  onChanged: (value) {
                    setState(() {
                      tipoChavePix = value.toString();
                    });
                  },
                ),
                const SizedBox(height: 15),
                Center(
                  child: tipoChavePix == 'CPF' ||
                          tipoChavePix == 'Telefone' ||
                          tipoChavePix == 'E-mail'
                      ? checkboxChaveExistente()
                      : const SizedBox.shrink(),
                ),
                TextFormField(
                  controller: _chavePixController,
                  maxLength: 32,
                  readOnly: !checkboxMarcado,
                  decoration: InputDecoration(
                    labelText: 'Valor da chave PIX:',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.monetization_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O valor da chave é obrigatório';
                    }
                    if (validador.validarChavePixSelecionada(
                            value, tipoChavePix) ==
                        false) {
                      return 'Chave PIX inválida';
                    }
                    return null;
                  },
                  inputFormatters: () {
                    if (tipoChavePix == 'CPF') {
                      return [BRMasks.cpf];
                    } else if (tipoChavePix == 'CNPJ') {
                      return [BRMasks.cnpj];
                    } else if (tipoChavePix == 'Telefone') {
                      return [BRMasks.mobilePhone];
                    } else {
                      return null;
                    }
                  }(),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: _descricaoController,
                  maxLength: 200,
                  decoration: InputDecoration(
                    labelText: 'Descrição:',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Descrição é obrigatória';
                    }
                    return null;
                  },
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _locaisEntregaController,
                        decoration: InputDecoration(
                          labelText: 'Possíveis locais de entrega:',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.location_on),
                          helperText:
                              'Ex: PAF II, Instituto de Biologia, Faculdade de Educação',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final local = _locaisEntregaController.text.trim();
                        if (local.isNotEmpty) {
                          setState(() {
                            _locaisEntrega.add(local);
                            _locaisEntregaController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const SizedBox(
                  height: 30,
                  child: Text('Locais de entrega selecionados:',
                      style: TextStyle(fontSize: 15)),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    for (var local in _locaisEntrega)
                      Chip(
                        label: Text(local),
                        onDeleted: () {
                          setState(() {
                            _locaisEntrega.remove(local);
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String? idUsuarioLogado = await ref
                          .read(usuarioServiceProvider)
                          .obterIdUsuarioLogado();

                      final empresaNova = empresa.copyWith(
                        nomeFantasia: _nomeFantasiaController.text,
                        chavePix: _chavePixController.text,
                        descricao: _descricaoController.text,
                        locaisEntrega: _locaisEntrega,
                        usuarioId: idUsuarioLogado!,
                      );

                      await ref
                          .read(empresaServiceProvider)
                          .criarEmpresa(empresaNova);

                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }
                  },
                  child: Text(empresa.id == null ? 'Cadastrar' : 'Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget checkboxChaveExistente() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    checkboxMarcado = value;
                    _chavePixController.dispose();
                  });
                }
              },
              tristate: false,
              value: checkboxMarcado,
              activeColor: const Color(0xFF6200EE),
            ),
            const Text(
              'Usar chave do meu usuário',
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
