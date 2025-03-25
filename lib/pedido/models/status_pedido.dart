// ignore: constant_identifier_names
enum StatusPedido { PENDENTE, CANCELADO, ENTREGUE, FINALIZADO }

extension StatusPedidoExtension on StatusPedido {
  String get nome {
    switch (this) {
      case StatusPedido.PENDENTE:
        return 'Pendente';
      case StatusPedido.CANCELADO:
        return 'Cancelado';
      case StatusPedido.ENTREGUE:
        return 'Entregue';
      case StatusPedido.FINALIZADO:
        return 'Finalizado';
      default:
        return '';
    }
  }
}
