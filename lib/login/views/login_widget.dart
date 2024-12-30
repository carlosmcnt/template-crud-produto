import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_crud_produto/login/services/login_service.dart';
import 'package:template_crud_produto/login/views/cadastro_widget.dart';
import 'package:template_crud_produto/produto/views/produto_list_widget.dart';

class LoginPage extends ConsumerStatefulWidget {

  const LoginPage({super.key});
  
  @override
  ConsumerState<LoginPage> createState() {
    return LoginPageState();
  }

}

class LoginPageState extends ConsumerState<LoginPage>{

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Login')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () async {

                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                 bool retornoLogin = await ref.read(loginServiceProvider).login(
                      _emailController.text.trim(),
                      _senhaController.text.trim(),
                      context,
                  );

                  if (!context.mounted) return;

                  if(retornoLogin) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProdutoListPage(),
                      )
                    );
                  }

                },
                label: const Text('Entrar'),
                icon: const Icon(Icons.login),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CadastroPage(),
                    ),
                  );
                },
                child: const Text('Não possui uma conta? Cadastre-se'),
              ),
              const SizedBox(height: 3),
              TextButton(
                onPressed: () async {
                  await ref.read(loginServiceProvider)
                        .redefinirSenha(_emailController.text.trim(), context);
                  
                  if (!context.mounted) return;
                },
                child: const Text('Esqueceu a senha?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
}