import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_crud_produto/empresa/models/empresa.dart';
import 'package:template_crud_produto/usuario/models/usuario.dart';
import 'package:template_crud_produto/usuario/services/usuario_service.dart';
import 'package:template_crud_produto/empresa/services/empresa_service.dart';

part 'menu_lateral_controller.g.dart';

@riverpod
class MenuLateralController extends _$MenuLateralController {
  @override
  FutureOr<Usuario?> build() async {
    state = const AsyncValue.loading();
    final usuarioLogado =
        await ref.read(usuarioServiceProvider).obterUsuarioLogado();
    state = AsyncValue.data(usuarioLogado!);
    return usuarioLogado;
  }

  Future<Empresa?> obterEmpresaLogada() async {
    final usuario = state.value;
    final empresaService = ref.read(empresaServiceProvider);
    final empresa = await empresaService.obterEmpresaPorUsuarioId(usuario!.id!);
    return empresa;
  }
}
