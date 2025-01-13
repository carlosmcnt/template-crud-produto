// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_crud_produto/usuario/models/usuario.dart';
import 'package:template_crud_produto/usuario/repositories/usuario_repository.dart';
import 'package:template_crud_produto/utils/estilos.dart';

part 'usuario_service.g.dart';

class UsuarioService {
  final UsuarioRepository usuarioRepository;
  Estilos estilos = Estilos();

  UsuarioService({required this.usuarioRepository});

  Future<bool> login(String email, String senha, BuildContext context) async {
    final resultado =
        await usuarioRepository.entrar(email: email, senha: senha);
    if (resultado != null) {
      estilos.snackbarStatus(mensagem: resultado, context: context, erro: true);
    } else {
      estilos.snackbarStatus(
          mensagem: 'Login realizado com sucesso!',
          context: context,
          erro: false);
      return true;
    }
    return false;
  }

  // Método para logout
  Future<void> logout() async {
    await usuarioRepository.sair();
  }

  Future<void> redefinirSenha(String email, BuildContext context) async {
    final resultado = await usuarioRepository.redefinirSenha(email: email);
    if (resultado != null) {
      estilos.snackbarStatus(mensagem: resultado, context: context, erro: true);
    } else {
      estilos.snackbarStatus(
          mensagem: 'E-mail de redefinição de senha enviado!',
          context: context,
          erro: false);
    }
  }

  Future<bool> registrar(
      {required String nome,
      required String email,
      required String cpf,
      required String senha,
      required String telefone,
      required BuildContext context}) async {
    final resultado = await usuarioRepository.registrar(
      nomeCompleto: nome,
      email: email,
      cpf: cpf,
      senha: senha,
      telefone: telefone,
    );
    if (resultado != null) {
      estilos.snackbarStatus(mensagem: resultado, context: context, erro: true);
    } else {
      estilos.snackbarStatus(
          mensagem: 'Cadastro realizado com sucesso!',
          context: context,
          erro: false);
      return true;
    }
    return false;
  }

  Future<String?> obterIdUsuarioLogado() async {
    return await usuarioRepository.obterIdUsuarioLogado();
  }

  Future<Usuario?> obterUsuarioLogado() async {
    return await usuarioRepository.obterUsuarioAtual();
  }

  Future<void> atualizarUsuario(Usuario usuario) async {
    await usuarioRepository.atualizarUsuario(usuario);
  }
}

@Riverpod(keepAlive: true)
UsuarioService usuarioService(Ref ref) {
  final repository = ref.watch(usuarioRepositoryProvider);
  return UsuarioService(usuarioRepository: repository);
}
