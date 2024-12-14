import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {

  final String? id;
  final String descricao;
  final double valorUnitario;
  final String tipo;
  final String sabor;
  final DateTime dataCadastro;
  final bool temGlutem;
  final bool temLactose;
  final DateTime dataUltimaAlteracao;

  Produto({this.id, required this.descricao, required this.valorUnitario, required this.tipo, required this.sabor, required this.dataCadastro, this.temGlutem = false, this.temLactose = false, required this.dataUltimaAlteracao});

  factory Produto.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Produto(
      id: doc.id,
      descricao: data['descricao'] ?? '',
      valorUnitario: (data['valorUnitario'] ?? 0.0).toDouble(),
      tipo: data['tipo'] ?? '',
      sabor: data['sabor'] ?? '',
      dataCadastro: DateTime.parse(data['dataCadastro'] ?? DateTime.now().toLocal()),
      temGlutem: data['temGlutem'] ?? false,
      temLactose: data['temLactose'] ?? false,
      dataUltimaAlteracao: DateTime.parse(data['dataUltimaAlteracao'] ?? DateTime.now().toLocal()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'valorUnitario': valorUnitario,
      'tipo': tipo,
      'sabor': sabor,
      'dataCadastro': dataCadastro.toLocal(),
      'temGlutem': temGlutem,
      'temLactose': temLactose,
      'dataUltimaAlteracao': dataUltimaAlteracao.toLocal(),
    };
  }

  Produto copyWith({
    String? id,
    String? descricao,
    double? valorUnitario,
    String? tipo,
    String? sabor,
    DateTime? dataCadastro,
    bool? temGlutem,
    bool? temLactose,
    DateTime? dataUltimaAlteracao,
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