import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:template_crud_produto/produto/controllers/produto_list_controller.dart';
import 'package:template_crud_produto/produto/produto.dart';
import 'package:template_crud_produto/produto/widgets/produto_edit_widget.dart';

class ProdutoListPage extends ConsumerWidget {

  const ProdutoListPage({super.key});

  void atualizar(WidgetRef ref) {
    ref.read(produtoListControllerProvider.notifier).verificarEstado();
  }

  Widget? informarErro(error, stackTrace) => Center(
    child: Column(
      children: [
        Text('Erro: $error'),
        Text('Stack trace: $stackTrace'),
      ],
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final produtoList = ref.watch(produtoListControllerProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Produtos'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final saved = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProdutoEditPage(
                  produto: Produto(
                    descricao: '',
                    valorUnitario: 0.0,
                    tipo: '',
                    sabor: '',
                    temGlutem: false,
                    temLactose: false,
                    dataCadastro: DateTime.now().toLocal().toString(),
                    dataUltimaAlteracao: DateTime.now().toLocal().toString(),
                  ),
                ),
              ),
            );
            if (saved != false) {
              atualizar(ref);
            }
          },
          child: const Icon(Icons.add),
        ),
        body: produtoList.when(
          data: (list) => buildProdutoList(ref, list),
          error: informarErro,
          loading: () => const CircularProgressIndicator(),
        )
    );
  }

  Widget? buildProdutoList(WidgetRef ref, List<Produto> produtos) => ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
        final produto = produtos[index];
        return ListTile(
            title: Text(produto.descricao),
            subtitle: Text('R\$ ${NumberFormat
                .currency(locale: 'pt_BR', symbol: '')
                .format(produto.valorUnitario)}'),
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
                          ref.read(produtoListControllerProvider.notifier).deletarProduto(produto);
                        },
                        child: const Text('Excluir'),
                    ),
                ],
              ),
            );
          },
        ),
        onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProdutoEditPage(produto: produto),
              ),
          );
        },
      );
    },
  );
}