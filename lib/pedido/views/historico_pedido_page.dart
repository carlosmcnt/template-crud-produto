import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:template_crud_produto/menu/views/menu_lateral.dart';
import 'package:template_crud_produto/pedido/controllers/historico_pedido_controller.dart';
import 'package:template_crud_produto/pedido/models/item_pedido.dart';
import 'package:template_crud_produto/pedido/models/pedido.dart';
import 'package:template_crud_produto/pedido/models/status_pedido.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:template_crud_produto/utils/gerador_codigo_pedido.dart';

class HistoricoPedidoPage extends ConsumerStatefulWidget {
  const HistoricoPedidoPage({super.key});

  @override
  ConsumerState<HistoricoPedidoPage> createState() {
    return HistoricoPedidoPageState();
  }
}

class HistoricoPedidoPageState extends ConsumerState<HistoricoPedidoPage> {
  List<Pedido> listaPedidosOrdenados = [];
  String statusSelecionado = "Todos";
  List<String> listaStatus = [];
  final TextEditingController _motivoCancelamentoController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    listaStatus = StatusPedido.values.map((status) => status.nome).toList();
  }

  @override
  Widget build(BuildContext context) {
    final formatadorData = DateFormat('EEE, d MMMM yyyy', 'pt_BR');

    final pedidos = ref.watch(historicoPedidoControllerProvider);

    pedidos.whenData((pedidos) {
      if (statusSelecionado == "Todos") {
        listaPedidosOrdenados = pedidos;
      } else {
        listaPedidosOrdenados = pedidos
            .where((pedido) => pedido.status == statusSelecionado)
            .toList();
      }
      listaPedidosOrdenados
          .sort((a, b) => b.dataPedido.compareTo(a.dataPedido));
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Histórico'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            initialValue: statusSelecionado,
            onSelected: (String novoStatus) {
              setState(() {
                statusSelecionado = novoStatus;
              });
            },
            itemBuilder: (BuildContext context) {
              return listaStatus.map((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: pedidos.when(
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(
              child: Text("Nenhum pedido encontrado."),
            );
          }
          return ListView.builder(
            itemCount: listaPedidosOrdenados.length,
            itemBuilder: (context, index) {
              final pedido = listaPedidosOrdenados[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatadorData.format(pedido.dataPedido.toDate()),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(FontAwesomeIcons.hashtag,
                                    color: Colors.black54),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Código do Pedido: ${GeradorCodigoPedido.codigoReduzido(pedido.id!)}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: StatusPedido.values
                                      .firstWhere((status) =>
                                          status.nome == pedido.status)
                                      .cor,
                                  size: 10,
                                ),
                                const SizedBox(width: 5),
                                Text("Status: ${(pedido.status)}"),
                                const Spacer(),
                                Text(pedido.isEncomenda
                                    ? 'Encomenda'
                                    : 'Pedido'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Valor a ser pago:",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              "R\$${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(pedido.valorTotal)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Botões
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    detalharPedido(pedido);
                                  },
                                  child: const Text(
                                    "Detalhes",
                                    style: TextStyle(color: Colors.purple),
                                  ),
                                ),
                                if (pedido.status == StatusPedido.PENDENTE.nome)
                                  TextButton(
                                    onPressed: () {
                                      cancelarPedido(pedido);
                                    },
                                    child: const Text(
                                      "Cancelar pedido",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text("Erro ao carregar pedidos: $error"),
        ),
      ),
      drawer: const MenuLateralWidget(),
    );
  }

  void detalharPedido(Pedido pedido) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Center(child: Text("Detalhes do Pedido")),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Observação: ${pedido.observacao}"),
                    const SizedBox(height: 8),
                    const Text("Itens do pedido:"),
                    for (var item in pedido.itensPedido)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: exibirDadosItemPedido(item),
                      ),
                    const SizedBox(height: 8),
                    if (pedido.motivoCancelamento != null &&
                        pedido.motivoCancelamento!.isNotEmpty)
                      Text(
                          "Motivo do cancelamento: ${pedido.motivoCancelamento}"),
                    const SizedBox(height: 8),
                    Text(
                        "Última alteração: ${DateFormat('dd/MM/yyyy HH:mm').format(pedido.dataUltimaAlteracao.toDate())}"),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Fechar"),
                ),
              ],
            ));
  }

  Widget exibirDadosItemPedido(ItemPedido item) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ref
          .read(historicoPedidoControllerProvider.notifier)
          .obterDadosItemPedido(item.produtoId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Erro: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final dados = snapshot.data!;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${dados['descricao']}"),
              const SizedBox(width: 8),
              Text(
                  "R\$${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(dados['preco'])}"),
              const SizedBox(width: 8),
              Text("(x${item.quantidade})"),
            ],
          );
        } else {
          return const Text("Dados não disponíveis");
        }
      },
    );
  }

  void cancelarPedido(Pedido pedido) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(FontAwesomeIcons.circleXmark,
            color: Colors.red, size: 40),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Column(
              children: [
                Text(
                  "Cancelar Pedido",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("Você tem certeza que deseja cancelar este pedido?",
                    textAlign: TextAlign.center),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _motivoCancelamentoController,
              decoration: InputDecoration(
                labelText: "Digite o motivo:",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                pedido.motivoCancelamento = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Campo obrigatório";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => {
              _motivoCancelamentoController.clear(),
            },
            child: const Text("Limpar"),
          ),
          TextButton(
            onPressed: () => {Navigator.of(context).pop()},
            child: const Text("Não"),
          ),
          TextButton(
            onPressed: () {
              if (_motivoCancelamentoController.text.isNotEmpty) {
                ref
                    .read(historicoPedidoControllerProvider.notifier)
                    .cancelarPedido(
                        pedido.id!, _motivoCancelamentoController.text);

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pedido cancelado com sucesso!"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Motivo de cancelamento obrigatório"),
                  ),
                );
              }
            },
            child: const Text("Sim"),
          ),
        ],
      ),
    );
  }
}
