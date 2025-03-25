import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_crud_produto/firebase/firebase.dart';
import 'package:template_crud_produto/pedido/models/pedido.dart';

part 'pedido_repository.g.dart';

class PedidoRepository {
  final FirebaseFirestore _firestore;

  PedidoRepository(this._firestore);

  Future<Pedido?> getPedidoPorId(String id) async {
    final snapshot = await _firestore.collection('pedidos').doc(id).get();
    if (snapshot.exists) {
      return Pedido.fromDocument(snapshot);
    }
    return null;
  }

  Stream<List<Pedido>> getPedidos() {
    return _firestore.collection('pedidos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Pedido.fromDocument(doc)).toList();
    });
  }

  Stream<List<Pedido>> getPedidosPorStatus(String status) {
    return _firestore
        .collection('pedidos')
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Pedido.fromDocument(doc)).toList();
    });
  }

  Stream<List<Pedido>> getPedidosPorCliente(String usuarioId) {
    return _firestore
        .collection('pedidos')
        .where('usuarioClienteId', isEqualTo: usuarioId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Pedido.fromDocument(doc)).toList();
    });
  }

  Stream<List> getPedidosPorVendedor(String usuarioId) {
    return _firestore
        .collection('pedidos')
        .where('usuarioVendedorId', isEqualTo: usuarioId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Pedido.fromDocument(doc)).toList();
    });
  }

  Future<Pedido> inserirPedido(Pedido pedido) async {
    final docRef = await _firestore.collection('pedidos').add(pedido.toMap());
    return pedido.copyWith(id: docRef.id);
  }
}

@riverpod
PedidoRepository pedidoRepository(Ref ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return PedidoRepository(firestore);
}
