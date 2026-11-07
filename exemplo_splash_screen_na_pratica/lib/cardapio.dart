// Bancada compartilhada: os dois exemplos importam este arquivo, e e o import
// que prova que ele e bancada.
//
// Simula o carregamento que todo app faz na abertura — ler preferencias, abrir
// o banco, buscar a configuracao no servidor. Num app de verdade estas linhas
// seriam I/O; aqui o `Future.delayed` mantem o tempo previsivel na gravacao.

class ItemDoCardapio {
  const ItemDoCardapio(this.nome, this.preco);

  final String nome;
  final double preco;
}

class Cardapio {
  /// O tempo que o app leva para ficar pronto. Dois segundos e o suficiente
  /// para a diferenca entre os dois exemplos aparecer na gravacao.
  static const demora = Duration(seconds: 2);

  static Future<List<ItemDoCardapio>> carregar() async {
    await Future.delayed(demora);
    return const [
      ItemDoCardapio('Espresso', 6.50),
      ItemDoCardapio('Coado da casa', 8.00),
      ItemDoCardapio('Cappuccino', 12.00),
      ItemDoCardapio('Pao de queijo', 7.50),
    ];
  }
}
