import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:template_crud_produto/menu/views/menu_lateral.dart';
import 'package:template_crud_produto/pedido/controllers/historico_pedido_controller.dart';
import 'package:template_crud_produto/pedido/models/item_pedido.dart';
import 'package:template_crud_produto/pedido/models/pedido.dart';
import 'package:template_crud_produto/pedido/models/status_pedido.dart';
import 'package:template_crud_produto/utils/gerador_codigo_pedido.dart';

class HistoricoPedidoPage extends ConsumerStatefulWidget {
  const HistoricoPedidoPage({super.key, required this.isHistoricoEmpresa});
  final bool isHistoricoEmpresa;

  @override
  ConsumerState<HistoricoPedidoPage> createState() =>
      _HistoricoPedidoPageState();
}

class _HistoricoPedidoPageState extends ConsumerState<HistoricoPedidoPage> {
  List<Pedido> listaPedidosFinal = [];
  String statusSelecionado = "Todos";
  late List<String> listaStatus;
  bool isOrdenacaoAscendente = false;
  int registrosPorPagina = 5;
  int paginaAtual = 1;
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

    final pedidosAsync =
        ref.watch(historicoPedidoControllerProvider(widget.isHistoricoEmpresa));

    List<Pedido> listaPedidos = _aplicarFiltros(pedidosAsync);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Histórico de Pedidos'),
        actions: [exibirFiltroStatus()],
      ),
      drawer: const MenuLateralWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.isHistoricoEmpresa) exibirPainelVendedor(pedidosAsync),
            exibirPaginacaoOrdenacao(),
            const Divider(),
            pedidosAsync.when(
              data: (lista) {
                if (lista.isEmpty) {
                  return const Center(child: Text("Nenhum pedido encontrado."));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listaPedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = listaPedidos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
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
                          exibirCardPedido(pedido),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text("Erro ao carregar pedidos: $error")),
            ),
            exibirPaginacao(),
          ],
        ),
      ),
    );
  }

  Widget exibirFiltroStatus() {
    return PopupMenuButton<String>(
      icon: const Icon(FontAwesomeIcons.filter),
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
    );
  }

  Widget exibirPaginacaoOrdenacao() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(FontAwesomeIcons.arrowDownWideShort),
              const SizedBox(width: 8),
              const Text("Registros por página: "),
              DropdownButton<int>(
                value: registrosPorPagina,
                items: [5, 10, 20].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text("$value"),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      registrosPorPagina = newValue;
                      paginaAtual = 1;
                    });
                  }
                },
              ),
            ],
          ),
          // Controle de ordenação
          Row(
            children: [
              const Text("Ordenação: "),
              const SizedBox(width: 8),
              Text(isOrdenacaoAscendente ? "Decrescente" : "Crescente"),
              Switch(
                value: isOrdenacaoAscendente,
                onChanged: (bool value) {
                  setState(() {
                    isOrdenacaoAscendente = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget exibirCardPedido(Pedido pedido) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com código do pedido
            Row(
              children: [
                const Icon(FontAwesomeIcons.hashtag, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Código do Pedido: ${GeradorCodigoPedido.codigoReduzido(pedido.id!)}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(),
            // Linha de status e tipo de pedido
            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: StatusPedido.values
                      .firstWhere((status) => status.nome == pedido.status)
                      .cor,
                  size: 10,
                ),
                const SizedBox(width: 5),
                Text("Status: ${pedido.status}"),
                const Spacer(),
                Text(pedido.isEncomenda ? 'Encomenda' : 'Pedido'),
              ],
            ),
            const SizedBox(height: 8),
            // Valor a ser pago
            const Text("Valor a ser pago:",
                style: TextStyle(color: Colors.black54)),
            Text(
              "R\$${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(pedido.valorTotal)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Botões de ação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => detalharPedido(pedido),
                  child: const Text("Detalhes",
                      style: TextStyle(color: Colors.purple)),
                ),
                if (pedido.status == StatusPedido.PENDENTE.nome)
                  TextButton(
                    onPressed: () => cancelarPedido(pedido),
                    child: const Text("Cancelar pedido",
                        style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Pedido> _aplicarFiltros(AsyncValue<List<Pedido>> pedidosAsync) {
    pedidosAsync.whenData((pedidos) {
      listaPedidosFinal = statusSelecionado == "Todos"
          ? pedidos
          : pedidos
              .where((pedido) => pedido.status == statusSelecionado)
              .toList();
      listaPedidosFinal.sort((a, b) => b.dataPedido.compareTo(a.dataPedido));
    });

    listaPedidosFinal.sort((a, b) {
      int cmp = a.dataPedido.toDate().compareTo(b.dataPedido.toDate());
      return isOrdenacaoAscendente ? -cmp : cmp;
    });

    int totalRegistros = listaPedidosFinal.length;
    int indiceInicial = (paginaAtual - 1) * registrosPorPagina;
    int indiceFinal = min(indiceInicial + registrosPorPagina, totalRegistros);
    return listaPedidosFinal.sublist(indiceInicial, indiceFinal);
  }

  Widget exibirPaginacao() {
    int totalPages = (listaPedidosFinal.length / registrosPorPagina).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed:
                paginaAtual > 1 ? () => setState(() => paginaAtual--) : null,
            icon: const Icon(Icons.arrow_back),
          ),
          Text("Página $paginaAtual de $totalPages"),
          IconButton(
            onPressed: paginaAtual < totalPages
                ? () => setState(() => paginaAtual++)
                : null,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  Widget exibirDadosItemPedido(ItemPedido item) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ref
          .read(historicoPedidoControllerProvider(widget.isHistoricoEmpresa)
              .notifier)
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

  Widget exibirPainelVendedor(AsyncValue<List<Pedido>> pedidosAsync) {
    List<Pedido> vendasConcluidas = [];
    pedidosAsync.whenData((pedidos) {
      vendasConcluidas = pedidos
          .where((pedido) => pedido.status == StatusPedido.PENDENTE.nome)
          .toList();
    });
    double totalVendas =
        vendasConcluidas.fold(0.0, (sum, pedido) => sum + pedido.valorTotal);
    int quantidadeVendas = vendasConcluidas.length;
    double ticketMedio =
        quantidadeVendas > 0 ? totalVendas / quantidadeVendas : 0.0;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Resumo de Vendas Concluídas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  exibirDadosResumoVendas(
                      "Total de Vendas", "$quantidadeVendas"),
                  exibirDadosResumoVendas("Valor Total",
                      "R\$${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(totalVendas)}"),
                  exibirDadosResumoVendas("Ticket Médio",
                      "R\$${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(ticketMedio)}"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget exibirDadosResumoVendas(String titulo, String valor) {
    return Column(
      children: [
        Text(titulo, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(valor,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
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
                Text("Motivo do cancelamento: ${pedido.motivoCancelamento}"),
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
      ),
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
            const Text(
              "Cancelar Pedido",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Você tem certeza que deseja cancelar este pedido?",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _motivoCancelamentoController,
              decoration: InputDecoration(
                labelText: "Digite o motivo:",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
            onPressed: () => _motivoCancelamentoController.clear(),
            child: const Text("Limpar"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Não"),
          ),
          TextButton(
            onPressed: () {
              if (_motivoCancelamentoController.text.isNotEmpty) {
                ref
                    .read(historicoPedidoControllerProvider(
                            widget.isHistoricoEmpresa)
                        .notifier)
                    .cancelarPedido(
                      pedido.id!,
                      _motivoCancelamentoController.text,
                      widget.isHistoricoEmpresa,
                    );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Pedido cancelado com sucesso!")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Motivo de cancelamento obrigatório")),
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
