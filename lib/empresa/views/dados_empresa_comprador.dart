import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:template_crud_produto/empresa/controllers/dados_empresa_controller.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/pedido/views/encomenda_page.dart';
import 'package:template_crud_produto/utils/tema.dart';

class DadosEmpresaCompradorPage extends ConsumerStatefulWidget {
  final Empresa empresa;

  const DadosEmpresaCompradorPage({super.key, required this.empresa});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DadosEmpresaCompradorPageState();
  }
}

class DadosEmpresaCompradorPageState
    extends ConsumerState<DadosEmpresaCompradorPage> {
  Empresa get empresa => widget.empresa;

  @override
  Widget build(BuildContext context) {
    final listaProdutos = ref.watch(dadosEmpresaControllerProvider);

    return Scaffold(
      appBar: Tema.appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  empresa.nomeFantasia,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Text(empresa.descricao)),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(FontAwesomeIcons.cartShopping),
                    label: const Text("Pedido"),
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EncomendaPage(
                              empresa: empresa,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(FontAwesomeIcons.truckFast),
                      label: const Text("Encomenda")),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(FontAwesomeIcons.boxOpen),
                  SizedBox(width: 10),
                  Text(
                    "Produtos:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: listaProdutos.when(
                  data: (produtos) => produtos
                      .map((produto) => ListTile(
                            title: Text(produto.descricao),
                            subtitle: Text(
                                "R\$ ${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(produto.valorUnitario)}"),
                            leading: const Icon(FontAwesomeIcons.gem),
                          ))
                      .toList(),
                  loading: () => const [CircularProgressIndicator()],
                  error: (e, stack) => [Text("Erro: $e")],
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(FontAwesomeIcons.mapLocationDot),
                  SizedBox(width: 10),
                  Text(
                    "Local (is) de entrega:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: empresa.locaisEntrega
                    .map((local) => Chip(
                        label: Text(local),
                        avatar: const Icon(FontAwesomeIcons.locationArrow)))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
