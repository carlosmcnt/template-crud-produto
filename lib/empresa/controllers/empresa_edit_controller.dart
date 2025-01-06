import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/empresa/services/empresa_service.dart';

part 'empresa_edit_controller.g.dart';

@riverpod
class EmpresaEditController extends _$EmpresaEditController{

  @override
  Future<Empresa> build(Empresa empresa) async {
    return empresa;
  }

  Future<void> inserirOuAtualizarEmpresa(Empresa empresa) async {
    final empresaService = ref.read(empresaServiceProvider);
    state = const AsyncValue.loading();
    if (empresa.id == null) {
      await empresaService.criarEmpresa(empresa);
    } else {
      await empresaService.atualizarEmpresa(empresa);
    }
    state = await AsyncValue.guard(() async {
      final result = await empresaService.obterEmpresaById(empresa.id!);
      if (result == null) {
        throw Exception('Empresa not found');
      }
      return result;
    });
  }

}