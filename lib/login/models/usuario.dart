import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Usuario {

  final String? id;
  final String nomeCompleto;
  final String email;
  final String telefone;
  final Timestamp dataCadastro;
  final Timestamp dataUltimaAlteracao;

  Usuario({required this.id, required this.nomeCompleto, required this.email, required this.telefone, required this.dataCadastro, required this.dataUltimaAlteracao});

  factory Usuario.fromFirebase(User firebaseUser, Map<String, dynamic> data) {
    return Usuario(
      id: firebaseUser.uid,
      nomeCompleto: data['nomeCompleto'],
      email: data['email'],
      telefone: data['telefone'],
      dataCadastro: data['dataCadastro'],
      dataUltimaAlteracao: data['dataUltimaAlteracao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nomeCompleto': nomeCompleto,
      'email': email,
      'telefone': telefone,
      'dataCadastro': dataCadastro,
      'dataUltimaAlteracao': dataUltimaAlteracao,
    };
  }

}