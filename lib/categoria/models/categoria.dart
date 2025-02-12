import 'package:cloud_firestore/cloud_firestore.dart';

class Categoria {
  final String? id;
  final String nome;
  final String descricao;
  final bool ativo;

  Categoria({
    this.id,
    required this.nome,
    required this.descricao,
    this.ativo = true,
  });

  factory Categoria.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Categoria(
      id: doc.id,
      nome: data['nome'] ?? '',
      descricao: data['descricao'] ?? '',
      ativo: data['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'ativo': ativo,
    };
  }
}
