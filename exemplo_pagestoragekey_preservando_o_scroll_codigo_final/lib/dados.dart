// dados.dart
// Os dados vivem FORA do State, num repositório em memória montado uma vez só.
//
// Isso é essencial para a aula: se a lista morasse dentro do State, trocar de
// aba perderia os dados E o lugar, e não daria para separar as duas coisas.

import 'package:material_ui/material_ui.dart';

class Repositorio {
  Repositorio._();

  static final instancia = Repositorio._();

  int montagens = 0;

  late final List<String> itens = _montar();

  List<String> _montar() {
    montagens++;
    return List<String>.generate(800, (i) => 'Item $i');
  }
}

// A linha da lista. Altura fixa de 80 para as contas de offset baterem.
class const LinhaDeItem({
  super.key,
  required final String texto,
  required final int indice,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListTile(
        leading: CircleAvatar(child: Text('$indice')),
        title: Text(texto),
        subtitle: Text('começa no offset ${indice * 80}'),
      ),
    );
  }
}

// O placar que separa DADOS de LUGAR — é a distinção central da aula.
class const Placar({
  super.key,
  required final double offset,
  required final bool destaque,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repo = Repositorio.instancia;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: destaque ? Colors.red.shade50 : Colors.green.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DADOS  -> itens: ${repo.itens.length}   '
            'montagens do repositório: ${repo.montagens}',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
          Text(
            'LUGAR  -> offset: ${offset.toStringAsFixed(1)}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: destaque ? Colors.red.shade900 : Colors.green.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
