import 'package:flutter/material.dart';

class Estilos {
  
  final ButtonStyle botaoLargo = TextButton.styleFrom(
      foregroundColor: Colors.white, minimumSize: const Size(88, 44),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      backgroundColor: Colors.grey,
  );

}