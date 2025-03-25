import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_crud_produto/pedido/models/pedido.dart';
import 'package:template_crud_produto/pedido/services/pedido_service.dart';
import 'package:template_crud_produto/usuario/services/usuario_service.dart';

part 'historico_pedido_controller.g.dart';

@riverpod
class HistoricoPedidoController extends _$HistoricoPedidoController {
  @override
  Future<List<Pedido>> build() async {
    state = const AsyncValue.loading();
    try {
      List<Pedido> pedidosList = [];
      final usuarioId =
          await ref.read(usuarioServiceProvider).obterIdUsuarioLogado();
      final pedidos =
          ref.read(pedidoServiceProvider).getPedidosPorCliente(usuarioId!);
      pedidosList = await pedidos.first;
      state = AsyncValue.data(pedidosList);
      return pedidosList;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return [];
    }
  }
}
