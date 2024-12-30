import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_crud_produto/firebase/firebase.dart';
import 'package:template_crud_produto/login/models/usuario.dart';

part 'login_repository.g.dart';

class LoginRepository {

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  LoginRepository(this._auth, this._firestore, this._storage);

  Future<String?> registrar({
    required String nomeCompleto,
    required String email,
    required String senha,
    required String telefone,
    required File fotoPerfil,
  }) async {
    try {

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final user = userCredential.user;
      if (user == null) throw FirebaseAuthException(code: 'user-not-found');

      const fotoPerfilUrl = '';

      await _firestore.collection('usuarios').doc(user.uid).set({
        'nomeCompleto': nomeCompleto,
        'email': email,
        'telefone': telefone,
        'fotoPerfil': fotoPerfilUrl,
        'dataCadastro': Timestamp.now(),
        'dataUltimaAlteracao': Timestamp.now(),
      });

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'O e-mail informado já está em uso';
        case 'weak-password':
          return 'A senha informada é muito fraca';
        default:
          return 'Erro ao registrar, tente novamente mais tarde';
      }
    }
    return null;
  }

  Future<Usuario?> obterUsuarioAtual() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('usuarios').doc(user.uid).get();
      if (doc.exists) {
        return Usuario.fromFirebase(user, doc.data()!);
      }
    }
    return null;
  }

  Future<void> sair() async {
    await _auth.signOut();
  }

  Future<String?> entrar({
    required String email,
    required String senha,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } on FirebaseAuthException {
      return 'Erro ao fazer login, verifique suas credenciais e tente novamente';
    }
    return null;
  }

  Future<String?> redefinirSenha({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      return 'Não foi possível enviar o e-mail de redefinição de senha, verifique o e-mail informado e tente novamente';
    }
    return null;
  }

}

@riverpod
LoginRepository loginRepository(Ref ref) {
  final FirebaseAuth auth = ref.watch(firebaseAuthProvider);
  final FirebaseFirestore firestore = ref.watch(firebaseFirestoreProvider);
  final FirebaseStorage storage = ref.watch(firebaseStorageProvider);
  return LoginRepository(auth, firestore, storage);
}