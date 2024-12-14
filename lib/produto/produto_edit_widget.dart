import 'package:flutter/material.dart';
import 'produto.dart';
import 'produto_service.dart';

class ProdutoEditPage extends StatefulWidget {
  final Produto produto;
  final ProdutoService produtoService;

  const ProdutoEditPage({super.key, required this.produto, required this.produtoService});

  @override
  State<ProdutoEditPage> createState() => ProdutoEditPageState();
}

class ProdutoEditPageState extends State<ProdutoEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descricaoController;
  late TextEditingController _valorUnitarioController;
  late TextEditingController _tipoController;
  late TextEditingController _saborController;
  bool _temGlutem = false;
  bool _temLactose = false;

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController(text: widget.produto.descricao);
    _valorUnitarioController = TextEditingController(
      text: widget.produto.valorUnitario > 0
          ? widget.produto.valorUnitario.toString()
          : '',
    );
    _tipoController = TextEditingController(text: widget.produto.tipo);
    _saborController = TextEditingController(text: widget.produto.sabor);
    _temGlutem = widget.produto.temGlutem;
    _temLactose = widget.produto.temLactose;
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorUnitarioController.dispose();
    _tipoController.dispose();
    _saborController.dispose();
    super.dispose();
  }

  Future<void> saveProduto() async {
    if (_formKey.currentState!.validate()) {
      final produto = widget.produto.copyWith(
        descricao: _descricaoController.text,
        valorUnitario: double.tryParse(_valorUnitarioController.text) ?? 0.0,
        tipo: _tipoController.text,
        sabor: _saborController.text,
        temGlutem: _temGlutem,
        temLactose: _temLactose,
        dataUltimaAlteracao: DateTime.now(),
      );

      if (produto.id == null) {
        await widget.produtoService.criarProduto(produto);
      } else {
        await widget.produtoService.atualizarProduto(produto);
      }

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto.id == null ? 'Novo Produto' : 'Editar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                controller: _valorUnitarioController,
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
                value: _temGlutem,
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
                onPressed: saveProduto,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}