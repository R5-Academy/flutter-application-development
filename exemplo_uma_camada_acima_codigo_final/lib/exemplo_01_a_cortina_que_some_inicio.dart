// exemplo_01_a_cortina_que_some_inicio.dart
// Um catálogo com três telas empilhadas: Home -> Categoria -> Produto.
//
// O botão "Simular 401 do servidor" já funciona: ele marca a sessão como
// expirada, e o painel do topo prova isso mudando para SESSÃO EXPIRADA.
//
// ! Só que o app não avisa o usuário. Ninguém é bloqueado, a tela continua
// ! clicável, e quem está usando não faz ideia de que perdeu a sessão.
//
// A tarefa: mostrar um aviso que cubra a tela quando a sessão cair.
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
    home: Stack(
      children: [
        TelaHome(expirada: _sessaoExpirada, aoExpirar: _expirarSessao),
        if (_sessaoExpirada) const AvisoDeSessao(),
      ],
    ),
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

// * A cortina visual, pronta. Ela ainda não é usada em lugar nenhum.
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
