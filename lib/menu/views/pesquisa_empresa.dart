import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:template_crud_produto/categoria/models/categoria.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/empresa/services/empresa_service.dart';
import 'package:template_crud_produto/empresa/views/dados_empresa_comprador.dart';
import 'package:template_crud_produto/utils/tema.dart';

class PesquisaEmpresa extends ConsumerStatefulWidget {
  final Categoria categoria;
  const PesquisaEmpresa({super.key, required this.categoria});

  @override
  ConsumerState<PesquisaEmpresa> createState() {
    return PesquisaEmpresaState();
  }
}

class PesquisaEmpresaState extends ConsumerState<PesquisaEmpresa> {
  Categoria get categoria => widget.categoria;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Empresa>> obterEmpresasPorCategoria(String categoriaId) {
    Future<Set<Empresa>> empresas = ref
        .watch(empresaServiceProvider)
        .obterListaEmpresasPorCategoriaDoProduto(categoriaId);
    return empresas.then((value) => value.toList());
  }

  List<Empresa> removerEmpresasDuplicadas(List<Empresa> empresas) {
    final empresasUnicas = <Empresa>[];
    final idsEmpresas = <String>{};
    for (final empresa in empresas) {
      if (!idsEmpresas.contains(empresa.id)) {
        idsEmpresas.add(empresa.id!);
        empresasUnicas.add(empresa);
      }
    }
    return empresasUnicas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Tema.appBar(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[300],
            child: Text(
              categoria.nome,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
            child: FutureBuilder<List<Empresa>>(
              future: obterEmpresasPorCategoria(categoria.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao carregar empresas: ${snapshot.error}'),
                  );
                } else {
                  final empresas = removerEmpresasDuplicadas(snapshot.data!);
                  if (empresas.isEmpty) {
                    return const Center(
                      child: Text(
                          'Nenhuma empresa que vende essa categoria de produto foi encontrada'),
                    );
                  } else {
                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      itemCount: empresas.length,
                      itemBuilder: (context, index) {
                        final empresa = empresas[index];
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DadosEmpresaCompradorPage(
                                  empresa: empresa,
                                ),
                              ),
                            );
                          },
                          leading: const Icon(FontAwesomeIcons.buildingFlag),
                          tileColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(empresa.nomeFantasia),
                          subtitle: empresa.locaisEntrega.isEmpty
                              ? const Text('Sem locais de entrega')
                              : RichText(
                                  text: TextSpan(
                                    children: [
                                      const WidgetSpan(
                                          child: Icon(Icons.location_on)),
                                      TextSpan(
                                        text: empresa.locaisEntrega.join(', '),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
