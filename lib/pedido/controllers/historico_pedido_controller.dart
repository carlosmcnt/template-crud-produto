import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_crud_produto/pedido/models/pedido.dart';
import 'package:template_crud_produto/pedido/services/pedido_service.dart';
import 'package:template_crud_produto/produto/models/produto.dart';
import 'package:template_crud_produto/produto/services/produto_service.dart';
import 'package:template_crud_produto/usuario/services/usuario_service.dart';

part 'historico_pedido_controller.g.dart';

@riverpod
class HistoricoPedidoController extends _$HistoricoPedidoController {
  @override
  Future<List<Pedido>> build() async {
    state = const AsyncValue.loading();
    try {
      final usuarioId =
          await ref.read(usuarioServiceProvider).obterIdUsuarioLogado();
      final pedidos = await ref
          .read(pedidoServiceProvider)
          .getPedidosPorCliente(usuarioId!);
      state = AsyncValue.data(pedidos);
      return pedidos;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return [];
    }
  }

  Future<void> cancelarPedido(
      String pedidoId, String motivoCancelamento) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(pedidoServiceProvider)
          .cancelarPedido(pedidoId, motivoCancelamento);
      build();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<Map<String, dynamic>> obterDadosItemPedido(String produtoId) async {
    final produto =
        await ref.read(produtoServiceProvider).getProdutoById(produtoId);
    return {
      'descricao': '${produto?.tipo} sabor ${produto?.sabor}',
      'preco': produto?.valorUnitario,
    };
  }
}
