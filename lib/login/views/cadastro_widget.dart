import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:template_crud_produto/login/services/login_service.dart';
import 'package:template_crud_produto/utils/estilos.dart';
import 'dart:io';

class CadastroPage extends ConsumerStatefulWidget {

  const CadastroPage({super.key});
  
  @override
  ConsumerState<CadastroPage> createState() {
    return CadastroPageState();
  }
}

class CadastroPageState extends ConsumerState<CadastroPage>{

  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _senhaController;
  late TextEditingController _telefoneController;
  late File? fotoPerfil;
  bool senhaVisivel = false;
  late String nomeArquivo = 'Nenhuma foto selecionada';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _senhaController = TextEditingController();
    _telefoneController = TextEditingController();
    fotoPerfil = null;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> selecionarFoto() async {
    final picker = ImagePickerPlugin();
    final imagem = await picker.getImageFromSource(
      source: ImageSource.gallery,
    );
    setState(() {
      fotoPerfil = File(imagem!.path);
      nomeArquivo = fotoPerfil!.path.split('/').last;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Cadastro')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome:',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail:',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o e-mail';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _senhaController,
                obscureText: !senhaVisivel,
                decoration: InputDecoration(
                  labelText: 'Senha:',
                  suffixIcon: IconButton(
                    icon: Icon(
                            senhaVisivel
                            ? Icons.lock_open
                            : Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                    onPressed: () {
                      setState(() {
                        senhaVisivel = !senhaVisivel;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe a senha';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  MaskedInputFormatter('(##)#####-####'),
                ],
                decoration: const InputDecoration(
                  labelText: 'Telefone:',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o telefone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Foto do Perfil: $nomeArquivo', style: const TextStyle(fontSize: 16)),
                  ElevatedButton.icon(
                    style: Estilos().botaoLargo,
                    onPressed: () async {
                      selecionarFoto();
                    },
                    label: const Text('Selecionar Foto'),
                    icon: const Icon(Icons.photo_camera),
                  ),
                ]
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {

                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  bool retornoCadastro = await ref.read(loginServiceProvider).registrar(
                    nome: _nomeController.text,
                    email: _emailController.text,
                    senha: _senhaController.text,
                    telefone: _telefoneController.text,
                    fotoPerfil: fotoPerfil!,
                    context: context,
                  );

                  if(!context.mounted) return;

                  if(retornoCadastro) {
                    Navigator.of(context).pop();
                  }

                },
                label: const Text('Cadastrar'),
                icon: const Icon(Icons.login),
              ),
            ],
          ),
        ),
      ),
    );
  }

}