import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_crud_produto/empresa/services/empresa_service.dart';
import 'package:template_crud_produto/pedido/models/pedido.dart';
import 'package:template_crud_produto/pedido/services/pedido_service.dart';
import 'package:template_crud_produto/produto/models/produto.dart';
import 'package:template_crud_produto/produto/services/produto_service.dart';
import 'package:template_crud_produto/usuario/services/usuario_service.dart';

part 'encomenda_controller.g.dart';

@riverpod
class EncomendaController extends _$EncomendaController {
  @override
  Future<List<Produto>> build() async {
    throw UnimplementedError();
  }

  Future<List<Produto>> listarProdutos(String empresaId) async {
    state = const AsyncValue.loading();
    try {
      final empresa =
          await ref.read(empresaServiceProvider).obterEmpresaPorId(empresaId);

      if (empresa != null) {
        final produtos = await ref
            .read(produtoServiceProvider)
            .getProdutosPorEmpresa(empresa.id!);
        state = AsyncValue.data(produtos);
        return produtos;
      } else {
        state = const AsyncValue.data([]);
        return [];
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return [];
    }
  }

  Future<List<String>> obterTiposDeProduto() async {
    final tipos = await ref.read(produtoServiceProvider).obterTiposDeProduto();
    return tipos;
  }

  Future<List<Produto>> obterProdutosPorTipo(String tipo) async {
    final produtos =
        await ref.read(produtoServiceProvider).obterProdutosPorTipo(tipo);
    return produtos;
  }

  Future<void> inserirPedido(Pedido pedido) async {
    final pedidoService = ref.read(pedidoServiceProvider);
    state = const AsyncValue.loading();
    if (pedido.id == null) {
      pedido = await pedidoService.inserirPedido(pedido);
    } else {
      return;
    }
    state = const AsyncValue.data([]);
  }

  Future<String> obterIdUsuarioLogado() async {
    final usuario = await ref.read(usuarioServiceProvider).obterUsuarioLogado();
    return usuario.id!;
  }
}
