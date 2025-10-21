import 'package:flutter/material.dart';
import 'api_config.dart';
import 'api_service.dart';

class TelaHistoricoAgendamentos extends StatefulWidget {
  const TelaHistoricoAgendamentos({super.key});

  @override
  State<TelaHistoricoAgendamentos> createState() =>
      _TelaHistoricoAgendamentosState();
}

class _TelaHistoricoAgendamentosState extends State<TelaHistoricoAgendamentos> {
  List<dynamic> historico = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    try {
      final data = await ApiService.get(ApiConfig.historyBookings);
      setState(() {
        historico = data;
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        historico = [];
      });
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
                          'Histórico de Agendamentos',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Todos os seus agendamentos passados',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Tabela de histórico
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
                                          'Carregando histórico...',
                                          style: TextStyle(
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : hasError || historico.isEmpty
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.history,
                                          size: 64,
                                          color: Color(0xFFcccccc),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Nenhum agendamento no histórico',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF666666),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Seus agendamentos aparecerão aqui',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Table(
                                        columnWidths: const {
                                          0: FlexColumnWidth(1.5),
                                          1: FlexColumnWidth(1.2),
                                          2: FlexColumnWidth(1.5),
                                          3: FlexColumnWidth(1),
                                        },
                                        children: [
                                          // Cabeçalho da tabela
                                          TableRow(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2db95c),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight: Radius.circular(
                                                      8,
                                                    ),
                                                  ),
                                            ),
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  12.0,
                                                ),
                                                child: Text(
                                                  'Quadra',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  12.0,
                                                ),
                                                child: Text(
                                                  'Data',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  12.0,
                                                ),
                                                child: Text(
                                                  'Horário',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  12.0,
                                                ),
                                                child: Text(
                                                  'Status',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Linhas da tabela com dados
                                          ...historico.asMap().entries.map((
                                            entry,
                                          ) {
                                            final index = entry.key;
                                            final agendamento = entry.value;
                                            final isConfirmed =
                                                agendamento['status'] ==
                                                'confirmed';

                                            return TableRow(
                                              decoration: BoxDecoration(
                                                color: index.isEven
                                                    ? Colors.white
                                                    : const Color(0xFFf8f8f8),
                                              ),
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    12.0,
                                                  ),
                                                  child: Text(
                                                    agendamento['court']?['name'] ??
                                                        'N/A',
                                                    style: const TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontSize: 13,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    12.0,
                                                  ),
                                                  child: Text(
                                                    _formatarData(
                                                      agendamento['start_time'],
                                                    ),
                                                    style: const TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontSize: 13,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    12.0,
                                                  ),
                                                  child: Text(
                                                    _formatarHorario(
                                                      agendamento['start_time'],
                                                      agendamento['end_time'],
                                                    ),
                                                    style: const TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontSize: 13,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    12.0,
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: isConfirmed
                                                          ? const Color(
                                                              0xFFe8f5e8,
                                                            )
                                                          : const Color(
                                                              0xFFfee,
                                                            ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      border: Border.all(
                                                        color: isConfirmed
                                                            ? const Color(
                                                                0xFF2db95c,
                                                              )
                                                            : const Color(
                                                                0xFFc33,
                                                              ),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      isConfirmed
                                                          ? 'Concluído'
                                                          : 'Cancelado',
                                                      style: TextStyle(
                                                        color: isConfirmed
                                                            ? const Color(
                                                                0xFF2db95c,
                                                              )
                                                            : const Color(
                                                                0xFFc33,
                                                              ),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
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

  String _formatarData(String data) {
    final date = DateTime.parse(data);
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatarHorario(String inicio, String fim) {
    final start = DateTime.parse(inicio);
    final end = DateTime.parse(fim);
    return '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  }
}
