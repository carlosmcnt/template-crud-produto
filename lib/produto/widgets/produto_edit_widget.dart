import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:template_crud_produto/produto/controllers/produto_list_controller.dart';
import 'package:template_crud_produto/produto/produto.dart';

class ProdutoEditPage extends ConsumerStatefulWidget {
  final Produto produto;

  const ProdutoEditPage({super.key, required this.produto});
  
  @override
  ConsumerState<ProdutoEditPage> createState() {
    return _ProdutoEditPageState();
  }
}

class _ProdutoEditPageState extends ConsumerState<ProdutoEditPage> {

  late TextEditingController _descricaoController;
  late TextEditingController _valorController;
  late TextEditingController _tipoController;
  late TextEditingController _saborController;

  bool _temLactose = false;
  bool _temGlutem = false;
  Produto get produto => widget.produto;

  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  double moedaParser(String value) {
    String normalized = value.replaceAll(currencyFormat.currencySymbol, '').trim();
    normalized = normalized.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0.0;
  }

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController(text: produto.descricao);
    _valorController = TextEditingController(
      text: widget.produto.valorUnitario > 0
          ? currencyFormat.format(widget.produto.valorUnitario).replaceAll(currencyFormat.currencySymbol, '')
          : '',
    );
    _tipoController = TextEditingController(text: produto.tipo);
    _saborController = TextEditingController(text: produto.sabor);

    _temLactose = produto.temLactose;
    _temGlutem = produto.temGlutem;
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _tipoController.dispose();
    _saborController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(produto.id == null ? 'Novo Produto' : 'Editar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Descrição é obrigatória';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  labelText: 'Valor Unitário',
                  prefixText: 'R\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Valor unitário é obrigatório';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Digite um valor válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(labelText: 'Tipo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tipo é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _saborController,
                decoration: const InputDecoration(labelText: 'Sabor'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sabor é obrigatório';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Contém Glúten'),
                value:  _temGlutem,
                onChanged: (value) {
                  setState(() {
                    _temGlutem = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Contém Lactose'),
                value: _temLactose,
                onChanged: (value) {
                  setState(() {
                    _temLactose = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  
                  final novoProduto = produto.copyWith(
                    descricao: _descricaoController.text,
                    valorUnitario: moedaParser(_valorController.text),
                    tipo: _tipoController.text,
                    sabor: _saborController.text,
                    temGlutem: _temGlutem,
                    temLactose: _temLactose,
                  );

                  await ref
                      .read(produtoListControllerProvider.notifier)
                      .inserirOuAtualizarProduto(novoProduto);
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
                child: Text(produto.id == null ? 'Criar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}