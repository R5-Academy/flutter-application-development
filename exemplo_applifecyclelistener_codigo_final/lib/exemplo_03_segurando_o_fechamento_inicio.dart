// exemplo_03_segurando_o_fechamento_inicio.dart
//
// Um formulario com alteracoes pendentes e um botao que fecha o aplicativo.
//
// Clique em "Editar" para sujar o rascunho e depois em "Fechar o app": ele
// fecha, e o que estava escrito se perde. Ninguem perguntou nada.
//
// ! Este exemplo so faz sentido no DESKTOP (macOS, Windows, Linux), onde o
// ! fechamento e cancelavel. No celular nao existe "pedir para fechar".

import 'dart:ui' show AppExitResponse, AppExitType;

import 'package:flutter/services.dart' show ServicesBinding;
import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaRascunho()));

class TelaRascunho extends StatefulWidget {
  const TelaRascunho({super.key});

  @override
  State<TelaRascunho> createState() => _TelaRascunhoState();
}

class _TelaRascunhoState extends State<TelaRascunho> {
  late final AppLifecycleListener _ciclo;
  bool _temAlteracoes = false;
  String _ultimaResposta = '—';

  @override
  void initState() {
    super.initState();
    _ciclo = AppLifecycleListener(
      onExitRequested: () async {
        if (_temAlteracoes) {
          return AppExitResponse.cancel;
        } else {
          return AppExitResponse.exit;
        }
      },
    );
  }

  @override
  void dispose() {
    _ciclo.dispose();
    super.dispose();
  }

  Future<void> _pedirParaFechar() async {
    final resposta = await ServicesBinding.instance.exitApplication(
      AppExitType.cancelable,
    );
    if (!mounted) return;
    setState(() => _ultimaResposta = resposta.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rascunho')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _temAlteracoes ? 'Ha alteracoes nao salvas.' : 'Tudo salvo.',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _temAlteracoes = true),
                  child: const Text('Editar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => setState(() => _temAlteracoes = false),
                  child: const Text('Salvar'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _pedirParaFechar,
              child: const Text('Fechar o app'),
            ),
            const SizedBox(height: 12),
            Text('resposta ao pedido: $_ultimaResposta'),
          ],
        ),
      ),
    );
  }
}
