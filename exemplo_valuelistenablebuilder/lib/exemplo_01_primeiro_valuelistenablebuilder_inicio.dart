// exemplo_01_primeiro_valuelistenablebuilder_inicio.dart
// Demonstra: o ponto de partida. Um contador com setState dentro de uma tela
// que tem outras partes. Serve para SEMEAR o problema: um número mudou, mas o
// build do State roda todo de novo - e junto com ele os filhos que não tem
// nada a ver com o contador.
//
// * O QUE MEDIR AO VIVO — os dois placares estão na tela (medido):
//   5 toques no +  ->  tela inteira:      6 builds  (1 inicial + 5)
//                  ->  painel de ofertas: 6 builds
//   O painel não depende do contador e mesmo assim reconstroi 6 vezes.
//   Guarde os dois números: no arquivo completo eles caem para 1 e 1.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaContador()));

// O placar da aula: cada peça conta os próprios builds e mostra o número na
// tela. Sem isso, "o painel reconstrói à toa" é uma frase; com isso, é um
// número que a turma lê e compara.
class const _Placar({required final String nome, required final int builds})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '$nome: $builds builds',
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}

// Um pedaco da tela que NÃO depende do contador. Ele recebe dados do State,
// então não da para marcar `const` na hora de usar - que e a situação normal de
// uma tela de verdade, onde quase tudo vem de um campo ou de uma requisição.
class const _PainelDeOfertas({required final List<String> ofertas})
    extends StatefulWidget {
  @override
  State<_PainelDeOfertas> createState() => _PainelDeOfertasState();
}

class _PainelDeOfertasState extends State<_PainelDeOfertas> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    _builds++;

    return Column(
      children: [
        const Text('Ofertas da semana'),
        for (final oferta in widget.ofertas) Text(oferta),
        _Placar(nome: 'painel de ofertas', builds: _builds),
      ],
    );
  }
}

class TelaContador extends StatefulWidget {
  const TelaContador({super.key});

  @override
  State<TelaContador> createState() => _TelaContadorState();
}

class _TelaContadorState extends State<TelaContador> {
  int _contador = 0;
  int _builds = 0;

  // Dados fixos da tela: não mudam nunca, nem quando o contador muda.
  final _ofertas = ['Fone com 20% off', 'Teclado com frete gratis'];

  @override
  Widget build(BuildContext context) {
    // ! Este contador sobe a cada setState: o build do State roda INTEIRO, e
    // ! com ele o painel abaixo, que não tem relação nenhuma com o contador.
    _builds++;

    return Scaffold(
      appBar: AppBar(title: const Text('Contador e painel de ofertas')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PainelDeOfertas(ofertas: _ofertas),
          const SizedBox(height: 24),
          Text('Total: $_contador', style: const TextStyle(fontSize: 32)),
          _Placar(nome: 'tela inteira', builds: _builds),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // setState marca o State inteiro para rebuild: o build acima roda todo.
        onPressed: () => setState(() => _contador++),
        child: const Icon(Icons.add),
      ),
    );
  }
}
