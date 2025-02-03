import 'package:br_validators/br_validators.dart';
import 'package:flutter/material.dart';
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
  bool desabilitarBotao = false;
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

    setState(() => desabilitarBotao = true);

    bool retornoCadastro = await ref
        .read(usuarioServiceProvider)
        .registrar(
          nome: _nomeController.text,
          email: _emailController.text,
          cpf: _cpfController.text,
          senha: _senhaController.text,
          telefone: _telefoneController.text,
          context: context,
        )
        .whenComplete(() {
      setState(() => desabilitarBotao = false);
    });

    if (!context.mounted) return;

    if (retornoCadastro) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).shadowColor,
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: Center(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _inicio(context),
                      _camposObrigatorios(context),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Já possui uma conta?",
                              textAlign: TextAlign.center),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Faça o login",
                                textAlign: TextAlign.center,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _inicio(context) {
    return Column(
      children: [
        Image.asset(
          'logo-nome.png',
          fit: BoxFit.cover,
          height: 250,
          width: 250,
        ),
        const Text(
          "Cadastre-se para continuar!",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        const Text("Preencha os campos abaixo para criar sua conta",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
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
            filled: true,
            prefixIcon: const Icon(Icons.numbers),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, informe o CPF corretamente';
            }
            if (!BRValidators.validateCPF(value)) {
              return 'Por favor, informe um CPF válido';
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
            BRMasks.mobilePhone,
          ],
          decoration: InputDecoration(
            hintText: "Telefone:",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
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
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: desabilitarBotao ? null : () => cadastrar(context),
          label: const Text('Cadastrar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          icon: const Icon(Icons.login),
        ),
      ],
    );
  }
}
