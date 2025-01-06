import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/empresa/services/empresa_service.dart';
import 'package:template_crud_produto/login/services/login_service.dart';

class EmpresaEditPage extends ConsumerStatefulWidget{

  final Empresa empresa;

  const EmpresaEditPage({super.key, required this.empresa});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return EmpresaEditPageState();
  }

}

class EmpresaEditPageState extends ConsumerState<EmpresaEditPage>{

  late TextEditingController _nomeFantasiaController;
  late TextEditingController _chavePixController;
  late TextEditingController _descricaoController;
  late TextEditingController _locaisEntregaController;
  List<String> _locaisEntrega = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        title: Center(child: Text(empresa.id == null ? 'Criar Empresa' : 'Alterar Empresa')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeFantasiaController,
                decoration: const InputDecoration(
                  labelText: 'Nome Fantasia:', 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  suffixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome Fantasia é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _chavePixController,
                decoration: const InputDecoration(
                  labelText: 'Chave Pix:',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  suffixIcon: Icon(Icons.qr_code),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Chave Pix é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.multiline,
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição:',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  suffixIcon: Icon(Icons.description),
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
              const SizedBox(height: 16),
              const Text('Possíveis locais de entrega:', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _locaisEntregaController,
                      decoration: const InputDecoration(
                        hintText: 'Ex: PAF II, Instituto de Biologia, Faculdade de Educação',
                        hintStyle: TextStyle(color: Colors.grey),
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
                child: Text('Locais de entrega selecionados:', style: TextStyle(fontSize: 16)),
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {

                    String? idUsuarioLogado = await ref.read(loginServiceProvider).obterIdUsuarioLogado();

                    final empresaNova = empresa.copyWith(
                      nomeFantasia: _nomeFantasiaController.text,
                      chavePix: _chavePixController.text,
                      descricao: _descricaoController.text,
                      locaisEntrega: _locaisEntrega,
                      usuarioId: idUsuarioLogado!,
                    );

                    await ref.read(empresaServiceProvider).criarEmpresa(empresaNova);

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
    );              
  } 

}