import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template_crud_produto/pedido/models/item_pedido.dart';

class Pedido {
  final String? id;
  final String usuarioClienteId;
  final String usuarioVendedorId;
  final List<ItemPedido> itensPedido;
  final String status;
  final Timestamp dataPedido;
  final double valorTotal;
  final String observacao;
  String? motivoCancelamento;
  final bool isEncomenda;
  final Timestamp dataUltimaAlteracao;

  Pedido({
    this.id,
    required this.usuarioClienteId,
    required this.usuarioVendedorId,
    required this.itensPedido,
    required this.status,
    required this.dataPedido,
    required this.valorTotal,
    required this.observacao,
    required this.motivoCancelamento,
    required this.isEncomenda,
    required this.dataUltimaAlteracao,
  });

  factory Pedido.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Pedido(
      id: doc.id,
      usuarioClienteId: data['usuarioClienteId'] ?? '',
      usuarioVendedorId: data['usuarioVendedorId'] ?? '',
      itensPedido: (data['itensPedido'] as List<dynamic>? ?? [])
          .map((item) => ItemPedido(
                id: item['id'],
                produtoId: item['produtoId'],
                quantidade: item['quantidade'],
              ))
          .toList(),
      status: data['status'] ?? '',
      dataPedido: data['dataPedido'] ?? Timestamp.now(),
      valorTotal: data['valorTotal'] ?? 0.0,
      observacao: data['observacao'] ?? '',
      motivoCancelamento: data['motivoCancelamento'] ?? '',
      isEncomenda: data['isEncomenda'] ?? false,
      dataUltimaAlteracao: data['dataUltimaAlteracao'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuarioClienteId': usuarioClienteId,
      'usuarioVendedorId': usuarioVendedorId,
      'itensPedido': itensPedido.map((item) => item.toMap()).toList(),
      'status': status,
      'dataPedido': dataPedido,
      'valorTotal': valorTotal,
      'observacao': observacao,
      'motivoCancelamento': motivoCancelamento,
      'isEncomenda': isEncomenda,
      'dataUltimaAlteracao': dataUltimaAlteracao,
    };
  }

  Pedido copyWith({
    String? id,
    String? usuarioClienteId,
    String? usuarioVendedorId,
    List<ItemPedido>? itensPedido,
    String? status,
    Timestamp? dataPedido,
    double? valorTotal,
    String? observacao,
    String? motivoCancelamento,
    bool? isEncomenda,
    Timestamp? dataUltimaAlteracao,
  }) {
    return Pedido(
      usuarioClienteId: usuarioClienteId ?? this.usuarioClienteId,
      usuarioVendedorId: usuarioVendedorId ?? this.usuarioVendedorId,
      itensPedido: itensPedido ?? this.itensPedido,
      status: status ?? this.status,
      dataPedido: dataPedido ?? this.dataPedido,
      valorTotal: valorTotal ?? this.valorTotal,
      observacao: observacao ?? this.observacao,
      motivoCancelamento: motivoCancelamento ?? this.motivoCancelamento,
      isEncomenda: isEncomenda ?? this.isEncomenda,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
    );
  }
}
