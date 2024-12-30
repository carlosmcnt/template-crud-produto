// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_crud_produto/login/repositories/login_repository.dart';

part 'login_service.g.dart';

class LoginService {

  final LoginRepository loginRepository;

  LoginService({required this.loginRepository});

  Future<bool> login(String email, String senha, BuildContext context) async {
    final resultado = await loginRepository.entrar(email: email, senha: senha);
    if (resultado != null) {
      snackbarStatus(mensagem: resultado, context: context, erro: true);
    }
    else {
      snackbarStatus(mensagem: 'Login realizado com sucesso!', context: context, erro: false);
      return true;
    }
    return false;
  }

  // Método para logout
  Future<void> logout() async {
    await loginRepository.sair();
  }

  Future<void> redefinirSenha(String email, BuildContext context) async {
    final resultado = await loginRepository.redefinirSenha(email: email);
    if (resultado != null) {
      snackbarStatus(mensagem: resultado, context: context, erro: true);
    }
    else {
      snackbarStatus(mensagem: 'E-mail de redefinição de senha enviado!', context: context, erro: false);
    }
  }

  Future<bool> registrar({required String nome, required String email, required String senha, required String telefone, required File fotoPerfil, required BuildContext context}) async {
    final resultado = await loginRepository.registrar(nomeCompleto: nome, email: email, senha: senha, telefone: telefone, fotoPerfil: fotoPerfil);
    if (resultado != null) {
      snackbarStatus(mensagem: resultado, context: context, erro: true);
    }
    else {
      snackbarStatus(mensagem: 'Cadastro realizado com sucesso!', context: context, erro: false);
      return true;
    }
    return false;
  }

  snackbarStatus({required String mensagem, required BuildContext context, required bool erro}) {
    SnackBar snackbar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(mensagem),
      backgroundColor: erro ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

}

@Riverpod(keepAlive: true)
LoginService loginService(Ref ref) {
  final repository = ref.watch(loginRepositoryProvider);
  return LoginService(loginRepository: repository);
}