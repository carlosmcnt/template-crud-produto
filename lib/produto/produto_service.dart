import 'package:template_crud_produto/produto/produto.dart';
import 'produto_repository.dart';

class ProdutoService {
  
  final ProdutoRepository produtoRepository;

  ProdutoService({required this.produtoRepository});

  Future<Produto?> getProdutoById(String id) async {
    return await produtoRepository.getProdutoPorId(id);
  }

  Stream<List<Produto>> getProdutos() {
    return produtoRepository.getProdutos();
  }

  Future<Produto> criarProduto(Produto produto) async {
    return await produtoRepository.inserirProduto(produto);
  }

  Future<void> atualizarProduto(Produto produto) async {
    await produtoRepository.atualizarProduto(produto);
  }

  Future<void> deletarProduto(String id) async {
    await produtoRepository.deletarProduto(id);
  }

}