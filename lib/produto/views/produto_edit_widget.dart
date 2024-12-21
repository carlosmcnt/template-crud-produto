import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:template_crud_produto/produto/controllers/produto_list_controller.dart';
import 'package:template_crud_produto/produto/models/produto.dart';

class ProdutoEditPage extends ConsumerStatefulWidget {
  final Produto produto;

  const ProdutoEditPage({super.key, required this.produto});
  
  @override
  ConsumerState<ProdutoEditPage> createState() {
    return ProdutoEditPageState();
  }
}

class ProdutoEditPageState extends ConsumerState<ProdutoEditPage> {

  late TextEditingController _descricaoController;
  late TextEditingController _valorController;
  late TextEditingController _tipoController;
  late TextEditingController _saborController;
  late TextEditingController _alergenosController;
  List<String> _alergenos = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _temLactose = false;
  bool _temGlutem = false;
  bool _vegano = false;
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
    _alergenosController = TextEditingController();

    _temLactose = produto.temLactose;
    _temGlutem = produto.temGlutem;
    _vegano = produto.vegano;
    _alergenos = List<String>.from(produto.alergenos);
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
        title: Center(child: Text(produto.id == null ? 'Novo Produto' : 'Editar Produto')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição do produto'),
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
                  if (moedaParser(value) <= 0) {
                    return 'Valor unitário deve ser maior que zero';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo do produto',
                  hintText: 'Ex: Bolo, Torta, Salgado',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tipo é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _saborController,
                decoration: const InputDecoration(
                  labelText: 'Sabor do produto',
                  hintText: 'Ex: Chocolate, Morango, Ninho',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sabor é obrigatório';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Contém glúten?'),
                value:  _temGlutem,
                onChanged: (value) {
                  setState(() {
                    _temGlutem = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Contém lactose?'),
                value: _temLactose,
                onChanged: (value) {
                  setState(() {
                    _temLactose = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('É vegano?'),
                value: _vegano,
                onChanged: (value) {
                  setState(() {
                    _vegano = value;
                  });
                },
              ),
              const Text('Possíveis componentes alérgenos', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _alergenosController,
                      decoration: const InputDecoration(
                        hintText: 'Ex: Amendoim, Castanhas, Soja',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final alergeno = _alergenosController.text.trim();
                      if (alergeno.isNotEmpty) {
                        setState(() {
                          _alergenos.add(alergeno);
                          _alergenosController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const SizedBox(
                height: 30,
                child: Text('Alérgenos selecionados:', style: TextStyle(fontSize: 16)),
              ),
              Wrap(
                spacing: 8,
                children: [
                  for (var alergeno in _alergenos)
                    Chip(
                      label: Text(alergeno),
                      onDeleted: () {
                        setState(() {
                          _alergenos.remove(alergeno);
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {

                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  
                  final novoProduto = produto.copyWith(
                    descricao: _descricaoController.text,
                    valorUnitario: moedaParser(_valorController.text),
                    tipo: _tipoController.text,
                    sabor: _saborController.text,
                    temGlutem: _temGlutem,
                    temLactose: _temLactose,
                    vegano: _vegano,
                    alergenos: _alergenos,
                  );

                  await ref
                      .read(produtoListControllerProvider.notifier)
                      .inserirOuAtualizarProduto(novoProduto);

                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }

                },
                child: Text(produto.id == null ? 'Cadastrar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}