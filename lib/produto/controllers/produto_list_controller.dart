import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_crud_produto/produto/models/produto.dart';
import 'package:template_crud_produto/produto/services/produto_service.dart';

part 'produto_list_controller.g.dart';

@riverpod
class ProdutoListController extends _$ProdutoListController{

  @override
  Future<List<Produto>> build() async {
    return ref.read(produtoServiceProvider).getProdutos();
  }

  Future<void> verificarEstado() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(ref.read(produtoServiceProvider).getProdutos);
  }

  Future<void> inserirOuAtualizarProduto(Produto produto) async {
    final produtoService = ref.read(produtoServiceProvider);
    state = const AsyncValue.loading();
    if (produto.id == null) {
      await produtoService.criarProduto(produto);
    } else {
      await produtoService.atualizarProduto(produto);
    }
    state = await AsyncValue.guard(produtoService.getProdutos);
  }

  Future<void> deletarProduto(Produto produto) async {
    final produtoService = ref.read(produtoServiceProvider);
    state = const AsyncValue.loading();
    await produtoService.deletarProduto(produto.id!);
    state = await AsyncValue.guard(produtoService.getProdutos);
  }

}