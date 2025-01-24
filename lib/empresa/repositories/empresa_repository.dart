import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/firebase/firebase.dart';

part 'empresa_repository.g.dart';

class EmpresaRepository {
  final FirebaseFirestore _firestore;

  EmpresaRepository(this._firestore);

  Future<Empresa?> obterEmpresaPorId(String id) async {
    final snapshot = await _firestore.collection('empresas').doc(id).get();
    if (snapshot.exists) {
      return Empresa.fromDocument(snapshot);
    }
    return null;
  }

  Stream<List<Empresa>> getEmpresas() {
    return _firestore.collection('empresas').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Empresa.fromDocument(doc)).toList();
    });
  }

  Future<Empresa> inserirEmpresa(Empresa empresa) async {
    final docRef = await _firestore.collection('empresas').add(empresa.toMap());

    return empresa.copyWith(id: docRef.id);
  }

  Future<void> atualizarEmpresa(Empresa empresa) async {
    await _firestore
        .collection('empresas')
        .doc(empresa.id)
        .update(empresa.toMap());
  }

  Future<void> deletarEmpresa(String id) async {
    await _firestore.collection('empresas').doc(id).delete();
  }

  Future<Empresa?> obterEmpresaPorUsuarioId(String usuarioId) async {
    final snapshot = await _firestore
        .collection('empresas')
        .where('usuarioId', isEqualTo: usuarioId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return Empresa.fromDocument(snapshot.docs.first);
    }
    return null;
  }
}

@riverpod
EmpresaRepository empresaRepository(Ref ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return EmpresaRepository(firestore);
}
