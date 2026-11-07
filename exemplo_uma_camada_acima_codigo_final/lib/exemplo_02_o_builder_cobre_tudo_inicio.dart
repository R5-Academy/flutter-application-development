// exemplo_02_o_builder_cobre_tudo_inicio.dart
// Partimos exatamente de onde o exemplo 01 parou: a cortina pendurada no
// `home`, funcionando na primeira tela e ficando offstage depois de um `push`.
//
// A tarefa: subir a cortina uma camada, para um lugar que fique ACIMA de todas
// as rotas — e não dentro de uma delas.
import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppCatalogo());

class AppCatalogo extends StatefulWidget {
  const AppCatalogo({super.key});

  @override
  State<AppCatalogo> createState() => _AppCatalogoState();
}

class _AppCatalogoState extends State<AppCatalogo> {
  bool _sessaoExpirada = false;

  void _expirarSessao() => setState(() => _sessaoExpirada = true);

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Catálogo',
    theme: ThemeData(colorSchemeSeed: Colors.indigo),
    builder: (context, child) {
      return Stack(
        children: [
          child ?? SizedBox.shrink(),
          if (_sessaoExpirada) const AvisoDeSessao(),
        ],
      );
    },
    home: TelaHome(expirada: _sessaoExpirada, aoExpirar: _expirarSessao),
  );
}

// * O painel é a instrumentação da aula: ele mostra o estado real da sessão em
// * qualquer tela, para separar "o estado não mudou" de "o aviso não apareceu".
class const _PainelDeSessao({required final bool expirada})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    color: expirada ? Colors.red.shade100 : Colors.green.shade100,
    child: Text(
      expirada ? 'SESSÃO EXPIRADA' : 'sessão: válida',
      textAlign: .center,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

// * A cortina visual, pronta desde o _inicio.
class const AvisoDeSessao({super.key, final VoidCallback? aoEntrarDeNovo})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.black54,
    child: Center(
      child: Card(
        margin: const EdgeInsets.all(32),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: .min,
            children: [
              Text(
                'Sessão expirada',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const Text('Entre de novo para continuar.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: aoEntrarDeNovo,
                child: const Text('Entrar de novo'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class const TelaHome({
  super.key,
  required final bool expirada,
  required final VoidCallback aoExpirar,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Home')),
    body: Column(
      children: [
        _PainelDeSessao(expirada: expirada),
        const Spacer(),
        FilledButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => TelaCategoria(aoExpirar: aoExpirar),
            ),
          ),
          child: const Text('Abrir categoria'),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: aoExpirar,
          child: const Text('Simular 401 do servidor'),
        ),
        const Spacer(),
      ],
    ),
  );
}

// O painel fica só na Home, e o motivo é honesto: as telas empilhadas foram
// construídas pelo `builder` da rota no momento do push, com o valor daquele
// instante. Elas não se reconstroem quando o estado lá em cima muda.
class const TelaCategoria({super.key, required final VoidCallback aoExpirar})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Categoria')),
    body: Center(
      child: FilledButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => TelaProduto(aoExpirar: aoExpirar),
          ),
        ),
        child: const Text('Abrir produto'),
      ),
    ),
  );
}

class const TelaProduto({super.key, required final VoidCallback aoExpirar})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Produto')),
    body: Center(
      child: FilledButton(
        onPressed: aoExpirar,
        child: const Text('Simular 401 do servidor'),
      ),
    ),
  );
}
