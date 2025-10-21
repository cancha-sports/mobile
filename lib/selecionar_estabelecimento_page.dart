import 'package:flutter/material.dart';
import 'api_config.dart';
import 'api_service.dart';
import 'novo_agendamento_page.dart';

class TelaSelecionarEstabelecimento extends StatefulWidget {
  const TelaSelecionarEstabelecimento({super.key});

  @override
  State<TelaSelecionarEstabelecimento> createState() =>
      _TelaSelecionarEstabelecimentoState();
}

class _TelaSelecionarEstabelecimentoState
    extends State<TelaSelecionarEstabelecimento> {
  List<dynamic> estabelecimentos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarEstabelecimentos();
  }

  Future<void> _carregarEstabelecimentos() async {
    try {
      final data = await ApiService.get(ApiConfig.establishments);
      setState(() {
        estabelecimentos = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar estabelecimentos: $e'),
          backgroundColor: const Color(0xFFc33),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf5f5f5), Color(0xFFe8f5e8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Header com logo e botão voltar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/logo_transparent.png',
                      height: 40,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF666666),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFe0e0e0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selecionar Estabelecimento',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Escolha onde deseja fazer seu agendamento',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Lista de estabelecimentos
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFfafafa),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFe0e0e0),
                              ),
                            ),
                            child: isLoading
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Color(0xFF2db95c),
                                              ),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Carregando estabelecimentos...',
                                          style: TextStyle(
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : estabelecimentos.isEmpty
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.business,
                                          size: 64,
                                          color: Color(0xFFcccccc),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Nenhum estabelecimento disponível',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF666666),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Tente novamente mais tarde',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: estabelecimentos.length,
                                    itemBuilder: (context, index) {
                                      final estabelecimento =
                                          estabelecimentos[index];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                            color: const Color(0xFFe0e0e0),
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                          leading: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2db95c),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.sports_soccer,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          title: Text(
                                            estabelecimento['name'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF333333),
                                            ),
                                          ),
                                          subtitle: const Text(
                                            'Clique para selecionar',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF666666),
                                            ),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: Color(0xFF666666),
                                          ),
                                          onTap: () async {
                                            // Aguarda o resultado da tela de agendamento
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TelaNovoAgendamento(
                                                      estabelecimento:
                                                          estabelecimento,
                                                    ),
                                              ),
                                            );

                                            // Se um agendamento foi feito, retorna true para atualizar a lista
                                            if (result == true) {
                                              Navigator.pop(context, true);
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
