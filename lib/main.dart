import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_empresa/produto/produto_repository.dart';
import 'package:crud_empresa/produto/produto_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crud_empresa/produto/produto_list_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseFirestore = FirebaseFirestore.instance;
  final produtoRepository = ProdutoRepository(firebaseFirestore);
  final produtoService = ProdutoService(produtoRepository: produtoRepository);

  runApp(
    ProviderScope(
      child: MaterialApp(
        home: ProdutoListPage(produtoService: produtoService),
      ),
    ),
  );
}