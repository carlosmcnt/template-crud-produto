import 'package:flutter/material.dart';
import 'package:flutter_cart/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:template_crud_produto/utils/roteador.dart';
import 'package:template_crud_produto/utils/tema.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var carrinho = FlutterCart();
  carrinho.initializeCart(isPersistenceSupportEnabled: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'App Pegue o Doce',
        debugShowCheckedModeBanner: false,
        home: Roteador(),
        theme: Tema.lightTheme,
        darkTheme: Tema.darkTheme,
        themeMode: ThemeMode.light,
        locale: const Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
      ),
    ),
  );
}
