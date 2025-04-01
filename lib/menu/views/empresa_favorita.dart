import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/menu/controllers/empresa_favorita_controller.dart';
import 'package:template_crud_produto/menu/views/menu_lateral.dart';
import 'package:template_crud_produto/utils/tema.dart';
import 'package:template_crud_produto/empresa/views/dados_empresa_comprador.dart';

class EmpresaFavorita extends ConsumerStatefulWidget {
  const EmpresaFavorita({super.key});

  @override
  ConsumerState<EmpresaFavorita> createState() {
    return EmpresaFavoritaState();
  }
}

class EmpresaFavoritaState extends ConsumerState<EmpresaFavorita> {
  late Future<List<Empresa>> listaEmpresas;

  Future<List<Empresa>> obterListaEmpresasFavoritas() {
    return ref
        .read(empresaFavoritaControllerProvider.notifier)
        .obterListaEmpresasFavoritasPorUsuarioLogado();
  }

  @override
  void initState() {
    super.initState();
    listaEmpresas = obterListaEmpresasFavoritas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Tema.appBar(),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.grey[300],
                  child: const Text(
                    'EMPRESAS FAVORITAS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<List<Empresa>>(
                    future: listaEmpresas,
                    builder: (context, snapshot) {
                      return _buildListaEmpresas(context, snapshot);
                    },
                  ),
                ),
              ],
            ),
          )),
      drawer: const MenuLateralWidget(),
    );
  }

  Widget _buildListaEmpresas(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasData && snapshot.data.isNotEmpty) {
        final empresas = snapshot.data as List<Empresa>;
        return ListView.builder(
          itemCount: empresas.length,
          itemBuilder: (context, index) {
            final empresa = empresas[index];
            return Card(
              child: ListTile(
                leading: const Icon(FontAwesomeIcons.buildingCircleCheck),
                title: Text(empresa.nomeFantasia),
                subtitle: Text(empresa.descricao),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DadosEmpresaCompradorPage(empresa: empresa)));
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          alertaRemocaoEmpresaFavorita(context, empresa),
                    );
                  },
                ),
              ),
            );
          },
        );
      } else {
        return const Center(
          child: Text('Nenhuma empresa favorita encontrada'),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  AlertDialog alertaRemocaoEmpresaFavorita(
      BuildContext context, Empresa empresa) {
    return AlertDialog(
      title:
          const Icon(FontAwesomeIcons.heartCrack, color: Colors.red, size: 50),
      content: Text(
          'Deseja realmente remover a empresa ${empresa.nomeFantasia} dos favoritos?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            await ref
                .read(empresaFavoritaControllerProvider.notifier)
                .removerEmpresaFavorita(empresa.id!);
            setState(() {
              listaEmpresas = obterListaEmpresasFavoritas();
            });
            if (!context.mounted) return;
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Empresa removida dos favoritos'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: const Text('Remover'),
        ),
      ],
    );
  }
}
