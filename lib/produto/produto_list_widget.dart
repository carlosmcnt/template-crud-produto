import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'produto_edit_widget.dart';
import 'produto_service.dart';
import 'produto.dart';

class ProdutoListPage extends StatefulWidget {
  final ProdutoService produtoService;

  const ProdutoListPage({super.key, required this.produtoService});

  @override
  State<ProdutoListPage> createState() => _ProdutoListPageState();
}

class _ProdutoListPageState extends State<ProdutoListPage> {
  late Future<List<Produto>> _produtosFuture;

  @override
  void initState() {
    super.initState();
    carregarTodos();
  }

  void carregarTodos() {
    setState(() {
      _produtosFuture = widget.produtoService.getProdutos().first;
    });
  }

  Future<void> inserirOuAtualizar(Produto? produto) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProdutoEditPage(produto: produto ?? Produto(
          descricao: '',
          valorUnitario: 0.0,
          tipo: '',
          sabor: '',
          dataCadastro: DateTime.now(),
          temGlutem: false,
          temLactose: false,
          dataUltimaAlteracao: DateTime.now(),
        ), produtoService: widget.produtoService,),
      ),
    );
    if (result == true) {
      carregarTodos();
    }
  }

  Future<void> deletar(Produto produto) async {
    await widget.produtoService.deletarProduto(produto.id!);
    carregarTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => inserirOuAtualizar(null),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Produto>>(
        future: _produtosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          } else {
            final produtos = snapshot.data!;
            return ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return ListTile(
                  title: Text(produto.descricao),
                  subtitle: Text('R\$ ${NumberFormat
                    .currency(locale: 'pt_BR', symbol: '')
                    .format(produto.valorUnitario)}'
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Excluir Produto'),
                          content: const Text('Tem certeza que deseja excluir este produto?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                deletar(produto);
                              },
                              child: const Text('Excluir'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  onTap: () => inserirOuAtualizar(produto),
                );
              },
            );
          }
        },
      ),
    );
  }
}
