// exemplo_02_carga_no_initstate_inicio.dart
// Ponto de partida: a carga do perfil disparada de dentro do `build`.
//
// Rode: funciona. O perfil aparece.
//
// ! Agora olhe o console e conte quantas vezes a busca foi disparada. O `build`
// ! roda muitas vezes — a cada `setState`, a cada mudança de tema, a cada
// ! rotação — e cada uma delas dispara a busca de novo.
//
// ? É o mesmo espírito do "não crie o Future dentro do `build`" da aula de
// ? FutureBuilder, e aqui não há FutureBuilder nenhum para culpar.
// ?
// ?   **qual método do ciclo de vida roda UMA vez, quando a tela nasce?**
//
// Repare também num detalhe de assinatura: esse método não pode ser `async`.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaPerfil()));

class const Usuario({required final String nome, required final String email});

// Simula uma "API": demora 2 segundos e devolve o perfil.
Future<Usuario> buscarUsuario() async {
  await Future.delayed(const Duration(seconds: 2));
  return const Usuario(
    nome: 'Grace Hopper',
    email: 'grace@academiadoflutter.com.br',
  );
}

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  // null enquanto carrega; vira o objeto quando o dado chega.
  Usuario? _usuario;

  Future<void> _carregar() async {
    debugPrint('Carregando Usuario');
    final usuario = await buscarUsuario();

    // A tela pode ter sido fechada durante os 2 segundos de espera.
    if (!mounted) return;

    setState(() => _usuario = usuario);
  }

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = _usuario;

    return Scaffold(
      appBar: AppBar(title: const Text('Meu perfil')),
      body: Center(
        // Enquanto _usuario e null, mostramos o loading; quando chega, o card.
        child: usuario == null
            ? const CircularProgressIndicator()
            : Card(
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        child: Icon(Icons.person, size: 32),
                      ),
                      const SizedBox(height: 16),
                      Text(usuario.nome, style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: 8),
                      Text(usuario.email),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
