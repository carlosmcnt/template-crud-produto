import 'package:flutter/material.dart';

class Estilos {
  snackbarStatus(
      {required String mensagem,
      required BuildContext context,
      required bool erro}) {
    SnackBar snackbar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(mensagem),
      backgroundColor: erro ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
