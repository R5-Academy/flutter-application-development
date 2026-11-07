// exemplo_03_simple_vs_alert_inicio.dart
// Ponto de partida: duas ações da tela de pedido, e **as duas** usando o
// `SimpleDialog` que a aula acabou de ensinar.
//
// A primeira está certa: escolher o tipo de entrega é uma lista de opções.
//
// ! A segunda não. "Cancelar o pedido?" virou uma lista com "Sim" e "Não" —
// ! duas linhas idênticas, do mesmo tamanho, na mesma cor, uma embaixo da
// ! outra.
// !
// ! Cancelar um pedido é irreversível. "Sim" e "Não" **não são equivalentes**, e
// ! apresentá-los assim tira exatamente o que uma confirmação precisa ter: a
// ! hierarquia que faz a pessoa parar e pensar.
//
// ? Os dois diálogos existem porque respondem a perguntas diferentes. Qual é a
// ? pergunta de cada um?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaComparacao()));

enum Envio(final String rotulo) {
  padrao('Entrega padrão'),
  expresso('Entrega expressa'),
  retirada('Retirar na loja');
}

class TelaComparacao extends StatefulWidget {
  const TelaComparacao({super.key});

  @override
  State<TelaComparacao> createState() => _TelaComparacaoState();
}

class _TelaComparacaoState extends State<TelaComparacao> {
  var _status = 'Toque em um dos botões';

  // * Uma lista de opções equivalentes: SimpleDialog é o certo aqui.
  Future<void> _escolherEnvio() async {
    final resultado = await showDialog<Envio>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: const Text('Como você quer receber?'),
          children: [
            for (final envio in Envio.values)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(dialogContext, envio),
                child: Text(envio.rotulo),
              ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (resultado != null) {
      setState(() => _status = 'Envio: ${resultado.rotulo}');
    }
  }

  // ! Uma decisão irreversível apresentada como lista de opções iguais.
  Future<void> _cancelarPedido() async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cancelar o pedido?'),
          content: Text(
            'O pedido será cancelado e o pagamento, estornado em até 5 dias.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Manter Pedido'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Cancelar Pedido'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    setState(() {
      _status = (resultado ?? false) ? 'Pedido cancelado' : 'Pedido mantido';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple × Alert')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: _escolherEnvio,
              child: const Text('Escolher envio'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _cancelarPedido,
              child: const Text('Cancelar pedido'),
            ),
            const SizedBox(height: 24),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
