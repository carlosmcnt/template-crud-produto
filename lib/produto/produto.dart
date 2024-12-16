import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {

  final String? id;
  final String descricao;
  final double valorUnitario;
  final String tipo;
  final String sabor;
  final String dataCadastro;
  final bool temGlutem;
  final bool temLactose;
  final String dataUltimaAlteracao;

  Produto({this.id, required this.descricao, required this.valorUnitario, required this.tipo, required this.sabor, required this.dataCadastro, this.temGlutem = false, this.temLactose = false, required this.dataUltimaAlteracao});

  factory Produto.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Produto(
      id: doc.id,
      descricao: data['descricao'] ?? '',
      valorUnitario: (data['valorUnitario'] ?? 0.0).toDouble(),
      tipo: data['tipo'] ?? '',
      sabor: data['sabor'] ?? '',
      dataCadastro: DateTime.parse(data['dataCadastro']).toString(),
      temGlutem: data['temGlutem'] ?? false,
      temLactose: data['temLactose'] ?? false,
      dataUltimaAlteracao: DateTime.parse(data['dataUltimaAlteracao']).toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'valorUnitario': valorUnitario,
      'tipo': tipo,
      'sabor': sabor,
      'dataCadastro': dataCadastro,
      'temGlutem': temGlutem,
      'temLactose': temLactose,
      'dataUltimaAlteracao': dataUltimaAlteracao,
    };
  }

  Produto copyWith({
    String? id,
    String? descricao,
    double? valorUnitario,
    String? tipo,
    String? sabor,
    String? dataCadastro,
    bool? temGlutem,
    bool? temLactose,
    String? dataUltimaAlteracao,
  }) {
    return Produto(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      valorUnitario: valorUnitario ?? this.valorUnitario,
      tipo: tipo ?? this.tipo,
      sabor: sabor ?? this.sabor,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      temGlutem: temGlutem ?? this.temGlutem,
      temLactose: temLactose ?? this.temLactose,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
    );
  }

}