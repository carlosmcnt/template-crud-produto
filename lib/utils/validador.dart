import 'package:flutter/material.dart';

class Validador {
  bool emailValido(String email) {
    String padrao =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(padrao);
    return (!regex.hasMatch(email)) ? false : true;
  }

  bool telefoneValido(String telefone) {
    String padrao = r'^\([1-9]{2}\) [2-9][0-9]{3,4}\-[0-9]{4}$';
    RegExp regex = RegExp(padrao);
    return (!regex.hasMatch(telefone)) ? false : true;
  }

  bool validarChavePixSelecionada(String valorChave, String tipo) {
    switch (tipo) {
      case 'E-mail':
        return emailValido(valorChave);
      case 'Chave Aleatória':
        return valorChave.length == 32;
      default:
        return false;
    }
  }

  listaTiposChavesPix() {
    return [
      const DropdownMenuItem(
        value: '',
        child: Text(''),
      ),
      const DropdownMenuItem(
        value: 'CPF',
        child: Text('CPF'),
      ),
      const DropdownMenuItem(
        value: 'CNPJ',
        child: Text('CNPJ'),
      ),
      const DropdownMenuItem(
        value: 'E-mail',
        child: Text('E-mail'),
      ),
      const DropdownMenuItem(
        value: 'Telefone',
        child: Text('Telefone'),
      ),
      const DropdownMenuItem(
        value: 'Chave Aleatória',
        child: Text('Chave Aleatória'),
      ),
    ];
  }
}
