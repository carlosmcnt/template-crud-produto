import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/produto/controllers/produto_list_controller.dart';
import 'package:template_crud_produto/produto/models/produto.dart';
import 'package:template_crud_produto/produto/views/produto_edit_widget.dart';
import 'package:template_crud_produto/menu/views/menu_lateral.dart';
import 'package:template_crud_produto/utils/tema.dart';

class ProdutoListPage extends ConsumerWidget {
  const ProdutoListPage({super.key, required this.empresa});
  final Empresa empresa;

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
      appBar: Tema.appBar(),
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
                  vegano: false,
                  alergenos: [],
                  empresaId: empresa.id!,
                  categoriaId: '',
                  dataCadastro: Timestamp.now(),
                  dataUltimaAlteracao: Timestamp.now(),
                ),
                empresa: empresa,
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
      ),
      drawer: const MenuLateralWidget(),
    );
  }

  Widget? buildProdutoList(WidgetRef ref, List<Produto> produtos) =>
      ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];
          return ListTile(
            title: Text(
                '${produto.tipo} sabor ${produto.sabor} - R\$ ${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(produto.valorUnitario)}'),
            subtitle: Text(produto.descricao),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Excluir Produto'),
                    content: const Text(
                        'Tem certeza que deseja excluir este produto?'),
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
                          ref
                              .read(produtoListControllerProvider.notifier)
                              .deletarProduto(produto);
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
                  builder: (context) =>
                      ProdutoEditPage(produto: produto, empresa: empresa),
                ),
              );
            },
          );
        },
      );
}
