// exemplo_03_merge_inicio.dart
// Ponto de partida: a tela de termos de uso que todo app tem. O botão
// "Continuar" só libera quando DUAS coisas são verdade ao mesmo tempo:
//
//   você rolou o texto até o fim   -> quem sabe disso é o ScrollController
//   você marcou o aceite           -> quem sabe disso é o Aceite, classe nossa
//
// Rode: funciona. Role até o fim, marque o aceite, e o botão libera.
//
// ! O problema não é o resultado, é a forma. São dois observáveis de tipos
// ! diferentes, e a saída natural foi aninhar um `ListenableBuilder` dentro do
// ! outro. Cada observável novo que o rodapé precisar acompanhar vira mais um
// ! nível de indentação em volta do mesmo rodapé.
//
// Repare que os dois builders não fazem nada de diferente um do outro: os dois
// só pedem "me avise quando mudar". Dá para pedir isso uma vez só.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaTermos()));

class Aceite extends ChangeNotifier {
  bool _marcado = false;

  bool get marcado => _marcado;

  void alternar() {
    _marcado = !_marcado;
    notifyListeners();
  }
}

class TelaTermos extends StatefulWidget {
  const TelaTermos({super.key});

  @override
  State<TelaTermos> createState() => _TelaTermosState();
}

class _TelaTermosState extends State<TelaTermos> {
  // Um observável do Flutter e um observável nosso, na mesma tela.
  final _rolagem = ScrollController();
  final _aceite = Aceite();

  late final _tela = Listenable.merge([_rolagem, _aceite]);

  static const _clausulas = [
    'Este aplicativo guarda no aparelho apenas o que você digitar nele, e nada '
        'sai daqui sem que você peça.',
    'O catálogo de produtos é atualizado de tempos em tempos. Preços exibidos '
        'fora do período de sincronização podem estar desatualizados.',
    'Você pode apagar sua conta a qualquer momento pelo menu de configurações. '
        'A remoção é imediata e não guardamos cópia.',
    'Notificações são opcionais e podem ser desligadas a qualquer momento, sem '
        'que isso afete o funcionamento do aplicativo.',
    'Em caso de falha de sincronização, o aplicativo mantém a última versão '
        'baixada e tenta novamente na próxima abertura.',
    'O suporte responde em até dois dias úteis pelo endereço informado na tela '
        'de contato.',
    'Estes termos podem mudar. Quando mudarem, esta tela aparece de novo e o '
        'aceite é pedido outra vez.',
    'Ao continuar, você declara que leu o texto acima até o fim e concorda com '
        'as condições descritas.',
  ];

  // Bancada: os números da rolagem só existem depois que a lista mede o
  // conteúdo. `hasClients` diz que o controller está ligado a um scrollable;
  // `hasContentDimensions` (scroll_position.dart:243) diz que ele já sabe o
  // tamanho. Sem as duas, ler `maxScrollExtent` estoura.
  bool get _leuAteOFim =>
      _rolagem.hasClients &&
      _rolagem.position.hasContentDimensions &&
      _rolagem.offset >= _rolagem.position.maxScrollExtent - 4;

  @override
  void dispose() {
    _rolagem.dispose();
    _aceite.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Termos de uso')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _rolagem,
              padding: const EdgeInsets.all(16),
              itemCount: _clausulas.length,
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text('${index + 1}. ${_clausulas[index]}'),
              ),
            ),
          ),
          const Divider(height: 1),
          // ! Um builder por observável, aninhados. O de fora escuta a rolagem,
          // ! o de dentro escuta o aceite, e o rodapé só existe no fundo dos dois.
          ListenableBuilder(
            listenable: _tela,
            builder: (context, child) => _Rodape(
              leuAteOFim: _leuAteOFim,
              marcado: _aceite.marcado,
              aoAlternar: _aceite.alternar,
              aoContinuar: _leuAteOFim && _aceite.marcado ? () {} : null,
            ),
          ),
        ],
      ),
    );
  }
}

class const _Rodape({
  required final bool leuAteOFim,
  required final bool marcado,
  required final VoidCallback aoAlternar,
  required final VoidCallback? aoContinuar,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            onPressed: aoAlternar,
            icon: Icon(
              marcado ? Icons.check_box : Icons.check_box_outline_blank,
            ),
            label: const Text('Li e aceito os termos'),
          ),
          const SizedBox(height: 8),
          Text(
            leuAteOFim ? 'texto lido até o fim' : 'role o texto até o fim',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: aoContinuar, child: const Text('Continuar')),
        ],
      ),
    );
  }
}
