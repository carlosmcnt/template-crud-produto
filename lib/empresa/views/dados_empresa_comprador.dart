import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:template_crud_produto/empresa/controllers/dados_empresa_controller.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/pedido/views/encomenda_page.dart';
import 'package:template_crud_produto/usuario/models/usuario_empresa.dart';
import 'package:template_crud_produto/usuario/repositories/usuario_empresa_repository.dart';
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
                    label: const Text("Realizar Pedido"),
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
                      icon: const Icon(FontAwesomeIcons.box),
                      label: const Text("Encomendar")),
                  ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              dialogoFavoritarEmpresa(context),
                        );
                      },
                      icon: const Icon(FontAwesomeIcons.star),
                      label: const Text("Favoritar Empresa")),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(FontAwesomeIcons.clipboardCheck),
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
                            leading: const Icon(FontAwesomeIcons.circleInfo),
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
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
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

  AlertDialog dialogoFavoritarEmpresa(BuildContext context) {
    return AlertDialog(
      title: const Icon(FontAwesomeIcons.heartCircleExclamation,
          color: Colors.red, size: 50),
      content: const Text("Deseja favoritar esta empresa?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () async {
            final usuarioLogadoId = await ref
                .read(dadosEmpresaControllerProvider.notifier)
                .obterIdUsuarioLogado();

            UsuarioEmpresa usuarioEmpresa = UsuarioEmpresa(
              empresaId: empresa.id!,
              usuarioId: usuarioLogadoId,
            );

            bool existe = await ref
                .read(usuarioEmpresaRepositoryProvider)
                .existeUsuarioEmpresa(usuarioEmpresa);

            if (!context.mounted) return;

            if (existe) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Empresa já foi favoritada anteriormente.")),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Empresa favoritada com sucesso.")),
              );

              await ref
                  .read(dadosEmpresaControllerProvider.notifier)
                  .adicionarEmpresaFavorita(usuarioEmpresa);
            }

            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
          child: const Text("Confirmar"),
        ),
      ],
    );
  }
}
