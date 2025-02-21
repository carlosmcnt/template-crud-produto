import 'package:br_validators/br_validators.dart';
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
      case 'CPF':
        return BRValidators.validateCPF(valorChave);
      case 'CNPJ':
        return BRValidators.validateCNPJ(valorChave);
      default:
        return false;
    }
  }

  List<DropdownMenuEntry<String>> listaTiposChavesPix() {
    return [
      const DropdownMenuEntry(
        value: '',
        label: '',
      ),
      const DropdownMenuEntry(
        value: 'CPF',
        label: 'CPF',
      ),
      const DropdownMenuEntry(
        value: 'CNPJ',
        label: 'CNPJ',
      ),
      const DropdownMenuEntry(
        value: 'E-mail',
        label: 'E-mail',
      ),
      const DropdownMenuEntry(
        value: 'Telefone',
        label: 'Telefone',
      ),
      const DropdownMenuEntry(
        value: 'Chave Aleatória',
        label: 'Chave Aleatória',
      ),
    ];
  }
}
