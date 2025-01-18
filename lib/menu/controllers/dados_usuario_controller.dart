import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_crud_produto/usuario/models/usuario.dart';
import 'package:template_crud_produto/usuario/services/usuario_service.dart';

part 'dados_usuario_controller.g.dart';

@riverpod
class DadosUsuarioController extends _$DadosUsuarioController {
  @override
  FutureOr<Usuario> build(Usuario usuario) async {
    state = const AsyncValue.loading();
    final usuarioLogado =
        await ref.read(usuarioServiceProvider).obterUsuarioLogado();
    state = AsyncValue.data(usuarioLogado!);
    return usuarioLogado;
  }

  Future<void> atualizarUsuario(Usuario usuario) async {
    final usuarioService = ref.read(usuarioServiceProvider);
    state = const AsyncValue.loading();
    await usuarioService.atualizarUsuario(usuario);
    state = await AsyncValue.guard(() => Future.value(usuario));
  }
}
