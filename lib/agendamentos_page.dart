import 'package:flutter/material.dart';
import 'api_config.dart';
import 'api_service.dart';
import 'historico_agendamentos_page.dart';
import 'selecionar_estabelecimento_page.dart';
import 'login_page.dart';

class TelaAgendamentos extends StatefulWidget {
  const TelaAgendamentos({super.key});

  @override
  State<TelaAgendamentos> createState() => _TelaAgendamentosState();
}

class _TelaAgendamentosState extends State<TelaAgendamentos> {
  List<dynamic> agendamentos = [];
  List<dynamic> courts = [];
  List<dynamic> establishments = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _carregarAgendamentos();
  }

  // Adicione este método para permitir o refresh externo
  Future<void> refreshAgendamentos() async {
    await _carregarAgendamentos();
  }

  Future<void> _carregarAgendamentos() async {
    try {
      final data = await ApiService.get(ApiConfig.upcomingBookings);

      // Buscar todas as quadras e estabelecimentos
      final courtsData = await ApiService.get(ApiConfig.courts);
      final establishmentsData = await ApiService.get(ApiConfig.establishments);

      setState(() {
        agendamentos = data;
        courts = courtsData;
        establishments = establishmentsData;
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        agendamentos = []; // Garante que a lista fique vazia em caso de erro
        courts = [];
        establishments = [];
      });
      // Não mostra mais o SnackBar para erros 404
    }
  }

  // Adicione este método para buscar o nome do estabelecimento
  String _getNomeEstabelecimento(int courtId) {
    try {
      final court = courts.firstWhere(
        (court) => court['id'] == courtId,
        orElse: () => null,
      );

      if (court != null) {
        final establishmentId = court['establishment_id'];
        final establishment = establishments.firstWhere(
          (est) => est['id'] == establishmentId,
          orElse: () => null,
        );

        return establishment?['name'] ?? 'N/A';
      }
    } catch (e) {
      print('Erro ao buscar estabelecimento: $e');
    }
    return 'N/A';
  }

  // Adicione este método para buscar o nome da quadra
  String _getNomeQuadra(int courtId) {
    try {
      final court = courts.firstWhere(
        (court) => court['id'] == courtId,
        orElse: () => null,
      );

      return court?['name'] ?? 'N/A';
    } catch (e) {
      print('Erro ao buscar quadra: $e');
    }
    return 'N/A';
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
            // Header com logo e logout
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
                      icon: const Icon(Icons.logout, color: Color(0xFF666666)),
                      onPressed: () {
                        ApiService.clearToken();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CanchaLoginPage(),
                          ),
                        );
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
                          'Agendamentos',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Seus próximos agendamentos',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Tabela de agendamentos
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
                                          'Carregando agendamentos...',
                                          style: TextStyle(
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : hasError || agendamentos.isEmpty
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 64,
                                          color: Color(0xFFcccccc),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Faça seu primeiro agendamento!',
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
                                          0: FlexColumnWidth(
                                            2,
                                          ), // Estabelecimento
                                          1: FlexColumnWidth(1.5), // Quadra
                                          2: FlexColumnWidth(1.2), // Data
                                          3: FlexColumnWidth(1.3), // Horário
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
                                              // NOVA COLUNA: Estabelecimento
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  12.0,
                                                ),
                                                child: Text(
                                                  'Estabelecimento',
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
                                            ],
                                          ),

                                          // Linhas da tabela com dados
                                          ...agendamentos.asMap().entries.map((
                                            entry,
                                          ) {
                                            final index = entry.key;
                                            final agendamento = entry.value;
                                            final courtId =
                                                agendamento['court_id'];
                                            return TableRow(
                                              decoration: BoxDecoration(
                                                color: index.isEven
                                                    ? Colors.white
                                                    : Color(0xFFf8f8f8),
                                              ),
                                              children: [
                                                // NOVA COLUNA: Estabelecimento
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    12.0,
                                                  ),
                                                  child: Text(
                                                    _getNomeEstabelecimento(
                                                      courtId,
                                                    ),
                                                    style: TextStyle(
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
                                                    _getNomeQuadra(courtId),
                                                    style: TextStyle(
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
                                                    style: TextStyle(
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
                                                    style: TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontSize: 13,
                                                    ),
                                                    textAlign: TextAlign.center,
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

                        const SizedBox(height: 24),

                        // Botões de ação
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF2db95c),
                                    Color(0xFF25a050),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF2db95c,
                                    ).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  // Aguarda o retorno da tela de novo agendamento e atualiza a lista
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TelaSelecionarEstabelecimento(),
                                    ),
                                  );

                                  // Se retornou true, recarrega os agendamentos
                                  if (result == true) {
                                    await _carregarAgendamentos();
                                  }
                                },
                                child: const Text(
                                  "Novo agendamento",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFF2db95c),
                                ),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TelaHistoricoAgendamentos(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Histórico de agendamentos",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2db95c),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
