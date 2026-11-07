// exemplo_04_sem_conexao_inicio.dart
// Ponto de partida: o caso real do banner — o app perdeu a conexão.
//
// O estado está lá: o cabeçalho da lista muda quando a rede cai.
//
// ! Mas esse aviso só existe **naquele ponto da tela**. Desligue a conexão e
// ! **role a lista**: o cabeçalho sai de vista e nada mais indica que o app
// ! está offline. A pessoa vai tocar num pedido e não vai entender por que
// ! falhou.
// !
// ! Um SnackBar também não resolve: sem `action` ele some em ~4 s, e a conexão
// ! pode ficar caída por minutos; com `action` ele fica, mas fica **por cima**
// ! do último item da lista, com um botão só, e sai se a pessoa arrastar.
//
// ? O aviso precisa **durar exatamente o tempo do problema** — aparecer quando
// ? cai, sair quando volta — e continuar visível role a lista para onde rolar.
//
// * O `SwitchListTile` do topo **simula a rede**. Num app real quem chamaria
// * `_alternarConexao` seria um listener de conectividade
// * (`connectivity_plus`), não um controle na tela.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: SemConexaoPage()));

class SemConexaoPage extends StatefulWidget {
  const SemConexaoPage({super.key});

  @override
  State<SemConexaoPage> createState() => _SemConexaoPageState();
}

class _SemConexaoPageState extends State<SemConexaoPage> {
  bool _online = true;

  void _alternarConexao(bool online) {
    // ! O estado muda, mas o aviso vive só no cabeçalho da lista.
    setState(() => _online = online);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sem conexão')),
      body: Column(
        children: [
          // Simula a rede caindo e voltando.
          SwitchListTile(
            title: const Text('Simular conexão'),
            value: _online,
            onChanged: _alternarConexao,
          ),
          const Divider(height: 0),
          Expanded(
            child: ListView(
              children: [
                // ! Este é o único aviso de "offline" — e ele rola junto.
                _CabecalhoDeStatus(online: _online),
                for (var i = 1; i <= 30; i++)
                  ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: Text('Pedido #${1000 + i}'),
                    subtitle: const Text('Toque para ver os detalhes'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class const _CabecalhoDeStatus({required final bool online})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            online ? Icons.wifi : Icons.wifi_off,
            size: 64,
            color: online ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 8),
          Text(online ? 'Online' : 'Offline'),
        ],
      ),
    );
  }
}
