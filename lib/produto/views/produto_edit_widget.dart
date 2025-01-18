import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/produto/controllers/produto_list_controller.dart';
import 'package:template_crud_produto/produto/models/produto.dart';
import 'package:template_crud_produto/utils/formatador.dart';
import 'package:template_crud_produto/utils/tema.dart';

class ProdutoEditPage extends ConsumerStatefulWidget {
  final Produto produto;
  final Empresa empresa;

  const ProdutoEditPage(
      {super.key, required this.produto, required this.empresa});

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
  NormalizadorMoeda normalizador = NormalizadorMoeda();

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController(text: produto.descricao);
    _valorController =
        TextEditingController(text: produto.valorUnitario.toString());
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
      appBar: Tema.appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                minLines: 3,
                maxLength: 200,
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição do produto:',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Descrição é obrigatória';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: 'Valor Unitário:',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FormatadorMoedaReal(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Valor unitário é obrigatório';
                  }
                  if (normalizador.normalizarMoeda(value) <= 0) {
                    return 'Valor unitário deve ser maior que zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _tipoController,
                decoration: InputDecoration(
                  labelText: 'Tipo do produto:',
                  hintText: 'Ex: Bolo, Torta, Salgado',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.emoji_food_beverage_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tipo é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _saborController,
                decoration: InputDecoration(
                  labelText: 'Sabor do produto:',
                  hintText: 'Ex: Chocolate, Morango, Ninho',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.food_bank_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sabor é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                title: const Text('Contém glúten?'),
                value: _temGlutem,
                thumbIcon: WidgetStateProperty.all(
                    const Icon(Icons.breakfast_dining_outlined)),
                onChanged: (value) {
                  setState(() {
                    _temGlutem = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Contém lactose?'),
                value: _temLactose,
                thumbIcon: WidgetStateProperty.all(
                    const Icon(Icons.local_drink_outlined)),
                onChanged: (value) {
                  setState(() {
                    _temLactose = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('É vegano?'),
                value: _vegano,
                thumbIcon: WidgetStateProperty.all(
                    const Icon(Icons.emoji_nature_outlined)),
                onChanged: (value) {
                  setState(() {
                    _vegano = value;
                  });
                },
              ),
              const Text('Possíveis componentes alérgenos:',
                  style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _alergenosController,
                      decoration: InputDecoration(
                        hintText: 'Ex: Amendoim, Castanhas, Soja',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.medical_services_outlined),
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
                child: Text('Alérgenos selecionados:',
                    style: TextStyle(fontSize: 16)),
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
                    valorUnitario:
                        normalizador.normalizarMoeda(_valorController.text),
                    tipo: _tipoController.text,
                    sabor: _saborController.text,
                    temGlutem: _temGlutem,
                    temLactose: _temLactose,
                    vegano: _vegano,
                    alergenos: _alergenos,
                    empresaId: widget.empresa.id!,
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
