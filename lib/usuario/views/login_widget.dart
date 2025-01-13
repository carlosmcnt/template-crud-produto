import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_crud_produto/usuario/services/usuario_service.dart';
import 'package:template_crud_produto/usuario/views/cadastro_widget.dart';
import 'package:template_crud_produto/usuario/views/menu_principal_widget.dart';
import 'package:template_crud_produto/produto/controllers/produto_list_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _senhaController;
  bool senhaVisivel = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _senhaController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> realizarLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    bool retornoLogin = await ref.read(usuarioServiceProvider).login(
          _emailController.text.trim(),
          _senhaController.text.trim(),
          context,
        );

    if (!context.mounted) return;

    if (retornoLogin) {
      ref.invalidate(produtoListControllerProvider);

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const MenuPrincipalWidget(),
      ));
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
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
                      _senhaEsquecida(context),
                      _cadastro(context),
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

  _cadastro(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Não possui uma conta?'),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CadastroPage(),
              ),
            );
          },
          child: const Text('Cadastre-se'),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  _senhaEsquecida(context) {
    return Center(
      child: TextButton(
        onPressed: () async {
          await ref
              .read(usuarioServiceProvider)
              .redefinirSenha(_emailController.text.trim(), context);

          if (!context.mounted) return;
        },
        child:
            const Text('Esqueceu a senha? Preencha seu e-mail e clique aqui'),
      ),
    );
  }

  _inicio(context) {
    return Column(
      children: [
        Image.asset(
          'logo.png',
          fit: BoxFit.cover,
          height: 150,
          width: 150,
        ),
        const Text(
          "Bem vindo ao app Pegue o Doce!",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        const Text("Faça login para continuar",
            style: TextStyle(
              fontSize: 16,
            )),
        const SizedBox(height: 30),
      ],
    );
  }

  _camposObrigatorios(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "E-mail:",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            filled: true,
            prefixIcon: const Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _senhaController,
          obscureText: !senhaVisivel,
          decoration: InputDecoration(
            hintText: "Senha:",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            filled: true,
            prefixIcon: const Icon(Icons.password),
            suffixIcon: IconButton(
              icon: Icon(
                senhaVisivel ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  senhaVisivel = !senhaVisivel;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: () async {
            await realizarLogin(context);
          },
          label: const Text(
            'Entrar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: const Icon(
            Icons.login,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
