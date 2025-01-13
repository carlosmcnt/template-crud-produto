import 'package:br_validators/br_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_crud_produto/usuario/services/usuario_service.dart';

import 'package:template_crud_produto/utils/formatador.dart';
import 'package:template_crud_produto/utils/validador.dart';

class CadastroPage extends ConsumerStatefulWidget {
  const CadastroPage({super.key});

  @override
  ConsumerState<CadastroPage> createState() {
    return CadastroPageState();
  }
}

class CadastroPageState extends ConsumerState<CadastroPage> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _cpfController;
  late TextEditingController _senhaController;
  late TextEditingController _repetirSenhaController;
  late TextEditingController _telefoneController;
  bool senhaVisivel = false;
  bool repetirSenhaVisivel = false;
  bool autoValidate = false;
  late String nomeArquivo = 'Nenhuma foto selecionada';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _cpfController = TextEditingController();
    _senhaController = TextEditingController();
    _repetirSenhaController = TextEditingController();
    _telefoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _senhaController.dispose();
    _repetirSenhaController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> cadastrar(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      setState(() => autoValidate = true);
      return;
    }

    bool retornoCadastro = await ref.read(usuarioServiceProvider).registrar(
          nome: _nomeController.text,
          email: _emailController.text,
          cpf: _cpfController.text,
          senha: _senhaController.text,
          telefone: _telefoneController.text,
          context: context,
        );

    if (!context.mounted) return;

    if (retornoCadastro) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _inicio(context),
                _camposObrigatorios(context),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Já possui uma conta?"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Faça o login",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _inicio(context) {
    return Column(
      children: [
        const Text(
          "Cadastre-se para continuar!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text("Preencha os campos abaixo para criar sua conta",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            )),
        const SizedBox(height: 50),
      ],
    );
  }

  _camposObrigatorios(context) {
    return Column(
      children: [
        TextFormField(
          controller: _nomeController,
          decoration: InputDecoration(
            hintText: "Nome:",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            fillColor: Colors.grey[200],
            filled: true,
            prefixIcon: const Icon(Icons.face),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, informe o nome';
            }
            return null;
          },
          inputFormatters: [
            FormatadorLetrasMaiusculas(),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "E-mail:",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            fillColor: Colors.grey[200],
            filled: true,
            prefixIcon: const Icon(Icons.email),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, informe o e-mail';
            }
            if (!Validador().emailValido(value)) {
              return 'Por favor, informe um e-mail válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _cpfController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            BRMasks.cpf,
          ],
          decoration: InputDecoration(
            hintText: "CPF:",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            fillColor: Colors.grey[200],
            filled: true,
            prefixIcon: const Icon(Icons.numbers),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 14) {
              return 'Por favor, informe o CPF corretamente';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _senhaController,
          obscureText: !senhaVisivel,
          decoration: InputDecoration(
            hintText: "Senha:",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            fillColor: Colors.grey[200],
            filled: true,
            prefixIcon: const Icon(Icons.password),
            suffixIcon: IconButton(
              icon: Icon(
                senhaVisivel ? Icons.visibility : Icons.visibility_off,
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
        const SizedBox(height: 10),
        TextFormField(
          controller: _repetirSenhaController,
          obscureText: !repetirSenhaVisivel,
          decoration: InputDecoration(
            hintText: "Confirme a senha:",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            fillColor: Colors.grey[200],
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, repita a senha';
            }
            if (value != _senhaController.text) {
              return 'As senhas não conferem';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _telefoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            MaskedInputFormatter('(##)#####-####'),
          ],
          decoration: InputDecoration(
            hintText: "Telefone:",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            fillColor: Colors.grey[200],
            filled: true,
            prefixIcon: const Icon(Icons.phone),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 14) {
              return 'Por favor, informe o telefone corretamente';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () async {
            await cadastrar(context);
          },
          label: const Text('Cadastrar',
              style: TextStyle(fontWeight: FontWeight.bold)),
          icon: const Icon(Icons.login),
        ),
      ],
    );
  }
}
