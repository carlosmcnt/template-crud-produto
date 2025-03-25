import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_crud_produto/pedido/models/pedido.dart';
import 'package:template_crud_produto/pedido/repositories/pedido_repository.dart';

part 'pedido_service.g.dart';

class PedidoService {
  final PedidoRepository pedidoRepository;

  PedidoService({required this.pedidoRepository});

  Future<Pedido> inserirPedido(Pedido pedido) async {
    return await pedidoRepository.inserirPedido(pedido);
  }

  Future<Pedido?> getPedidoPorId(String id) async {
    return await pedidoRepository.getPedidoPorId(id);
  }

  Stream<List<Pedido>> getPedidos() {
    return pedidoRepository.getPedidos();
  }

  Stream<List<Pedido>> getPedidosPorStatus(String status) {
    return pedidoRepository.getPedidosPorStatus(status);
  }

  Stream<List<Pedido>> getPedidosPorCliente(String usuarioId) {
    return pedidoRepository.getPedidosPorCliente(usuarioId);
  }
}

@Riverpod(keepAlive: true)
PedidoService pedidoService(Ref ref) {
  final repository = ref.watch(pedidoRepositoryProvider);
  return PedidoService(pedidoRepository: repository);
}
