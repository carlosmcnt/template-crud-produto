import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:template_crud_produto/empresa/controllers/dados_empresa_controller.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/empresa/views/empresa_edit_widget.dart';
import 'package:template_crud_produto/pedido/views/historico_pedido_page.dart';
import 'package:template_crud_produto/produto/controllers/produto_list_controller.dart';
import 'package:template_crud_produto/produto/models/produto.dart';
import 'package:template_crud_produto/produto/views/produto_edit_widget.dart';
import 'package:template_crud_produto/utils/tema.dart';

class DadosEmpresaPage extends ConsumerStatefulWidget {
  final Empresa empresa;

  const DadosEmpresaPage({super.key, required this.empresa});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DadosEmpresaPageState();
  }
}

class DadosEmpresaPageState extends ConsumerState<DadosEmpresaPage> {
  Empresa get empresa => widget.empresa;

  @override
  void initState() {
    super.initState();
  }

  Map<String, List<Produto>> agruparProdutosPorTipo(List<Produto> produtos) {
    final listaAgrupados = <String, List<Produto>>{};
    for (final produto in produtos) {
      if (!listaAgrupados.containsKey(produto.tipo)) {
        listaAgrupados[produto.tipo] = [];
      }
      listaAgrupados[produto.tipo]!.add(produto);
    }
    return listaAgrupados;
  }

  @override
  Widget build(BuildContext context) {
    final listaProdutos = ref.watch(dadosEmpresaControllerProvider);

    return Scaffold(
      appBar: Tema.appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              child: Column(
                children: [
                  Card(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            FontAwesomeIcons.store,
                            size: 50,
                            color: Colors.black,
                          ),
                          Text(
                            empresa.nomeFantasia,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            empresa.descricao,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
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
                      },
                      icon: const Icon(FontAwesomeIcons.circlePlus),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                      ),
                      label: const Text('Adicionar Produto')),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EmpresaEditPage(
                              empresa: empresa,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(FontAwesomeIcons.penToSquare),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                      ),
                      label: const Text('Alterar Empresa')),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const HistoricoPedidoPage(
                                  isHistoricoEmpresa: true)),
                        );
                      },
                      icon: const Icon(FontAwesomeIcons.clockRotateLeft),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                      ),
                      label: const Text('Histórico de Vendas')),
                  const SizedBox(height: 20),
                  listaProdutos.when(data: (produtos) {
                    final produtosAgrupados = agruparProdutosPorTipo(produtos);
                    return ListView(
                      shrinkWrap: true,
                      children: produtosAgrupados.entries
                          .map(
                            (entry) => organizarProdutosPorTipo(
                                context, entry.key, entry.value),
                          )
                          .toList(),
                    );
                  }, loading: () {
                    return const Center(child: CircularProgressIndicator());
                  }, error: (error, stack) {
                    return const Center(
                      child: Column(
                        children: [
                          Text('Erro ao carregar produtos'),
                        ],
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget organizarProdutosPorTipo(
      BuildContext context, String tipo, List<Produto> produtos) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tipo.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: produtos
                  .map(
                    (produto) => ListTile(
                      leading: const Icon(FontAwesomeIcons.cookieBite),
                      title: Text(produto.sabor,
                          style: const TextStyle(fontSize: 20)),
                      subtitle: Text(
                          'R\$ ${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(produto.valorUnitario)}',
                          style: const TextStyle(fontSize: 16)),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProdutoEditPage(
                            produto: produto,
                            empresa: empresa,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever),
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
                                        .read(produtoListControllerProvider
                                            .notifier)
                                        .deletarProduto(produto);
                                  },
                                  child: const Text('Excluir'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
