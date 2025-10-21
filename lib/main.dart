import 'package:flutter/material.dart';

void main() {
  runApp(const CanchaApp());
}

class CanchaApp extends StatelessWidget {
  const CanchaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cancha",
      home: CanchaLoginPage(),
    );
  }
}

class CanchaLoginPage extends StatelessWidget {
  // Removed const from the constructor because of the TextEditingController fields
  const CanchaLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The fields themselves can be final but the class cannot be const
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF0D47A1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "BEM VINDO AO\nCANCHA!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Campo de email
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Insira seu email",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo de senha
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Insira sua senha",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                // Botão "Esqueci minha senha"
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaEsqueciSenha(),
                        ),
                      );
                    },
                    child: const Text(
                      "Esqueci minha senha",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Botão Entrar
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TelaAgendamentos(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("ENTRAR"),
                ),
                const SizedBox(height: 12),

                // Botão Registrar
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaRegistrar()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("REGISTRAR"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TelaEsqueciSenha extends StatelessWidget {
  const TelaEsqueciSenha({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperar Senha")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Digite seu email para receber o link de recuperação:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para enviar email de recuperação
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Link enviado para ${emailController.text}'),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text("Enviar Link"),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaRegistrar extends StatelessWidget {
  // Removed const from the constructor for the same reason
  const TelaRegistrar({super.key});

  @override
  Widget build(BuildContext context) {
    // The fields themselves can be final but the class cannot be const
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();
    final TextEditingController confirmarSenhaController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Registrar")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: "Nome Completo",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmarSenhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirmar Senha",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (senhaController.text != confirmarSenhaController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('As senhas não coincidem')),
                  );
                  return;
                }
                // Lógica de registro
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Registro realizado para ${emailController.text}',
                    ),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("REGISTRAR"),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaAgendamentos extends StatelessWidget {
  const TelaAgendamentos({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados de exemplo para a tabela
    final List<Map<String, String>> agendamentos = [
      {'quadra': 'Quadra 1', 'data': '20/05/2023', 'horario': '14:00 - 15:00'},
      {'quadra': 'Quadra 2', 'data': '21/05/2023', 'horario': '16:00 - 17:00'},
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 180, 224),
      appBar: AppBar(
        title: const Text('Olá, usuário!', style: TextStyle(fontSize: 16)),
        backgroundColor: const Color.fromARGB(255, 185, 180, 224),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Agendamentos',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Tabela de agendamentos
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    children: [
                      // Cabeçalho da tabela
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey.shade200),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Quadra',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Data',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Horário',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),

                      // Linhas da tabela com dados
                      ...agendamentos.map((agendamento) {
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                agendamento['quadra']!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                agendamento['data']!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                agendamento['horario']!,
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

            const SizedBox(height: 20),
            const Divider(color: Colors.white),
            const SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 112, 111, 121),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaHistoricoAgendamentos(),
                  ),
                );
              },
              child: const Text(
                "Histórico de agendamentos",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaNovoAgendamento(
                      precosQuadras: {
                        'Quadra 1': 50.00,
                        'Quadra 2': 60.00,
                        'Quadra 3': 70.00,
                        'Quadra 4': 80.00,
                      },
                    ),
                  ),
                );
              },
              child: const Text(
                "Novo Agendamento",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaHistoricoAgendamentos extends StatelessWidget {
  const TelaHistoricoAgendamentos({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados de exemplo para o histórico
    final List<Map<String, String>> historico = [
      {
        'quadra': 'Quadra 1',
        'data': '10/05/2023',
        'horario': '10:00 - 11:00',
        'status': 'Concluído',
      },
      {
        'quadra': 'Quadra 3',
        'data': '15/05/2023',
        'horario': '18:00 - 19:00',
        'status': 'Cancelado',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Agendamentos'),
        backgroundColor: const Color.fromARGB(255, 185, 180, 224),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            children: [
              // Cabeçalho da tabela
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.shade200),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Quadra',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Data',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Horário',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              // Linhas da tabela com dados
              ...historico.map((item) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item['quadra']!, textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item['data']!, textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['horario']!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['status']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: item['status'] == 'Concluído'
                              ? Colors.green
                              : Colors.red,
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
    );
  }
}

class TelaNovoAgendamento extends StatefulWidget {
  final Map<String, double> precosQuadras;

  const TelaNovoAgendamento({super.key, required this.precosQuadras});

  @override
  State<TelaNovoAgendamento> createState() => _TelaNovoAgendamentoState();
}

class _TelaNovoAgendamentoState extends State<TelaNovoAgendamento> {
  String? quadraSelecionada;
  DateTime? dataSelecionada;
  TimeOfDay? horarioInicioSelecionado;
  TimeOfDay? horarioFimSelecionado;
  double valorTotal = 0.0;
  int duracaoHoras = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Agendamento'),
        backgroundColor: const Color.fromARGB(255, 185, 180, 224),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Quadra',
                border: OutlineInputBorder(),
              ),
              initialValue: quadraSelecionada,
              items: widget.precosQuadras.keys.map((quadra) {
                return DropdownMenuItem(
                  value: quadra,
                  child: Text(
                    '$quadra - R\$${widget.precosQuadras[quadra]!.toStringAsFixed(2)}/h',
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  quadraSelecionada = value;
                  _calcularValorTotal();
                });
              },
            ),
            const SizedBox(height: 16),
            // Seleção de data
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Data',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (picked != null) {
                  setState(() {
                    dataSelecionada = picked;
                  });
                }
              },
              controller: TextEditingController(
                text: dataSelecionada != null
                    ? '${dataSelecionada!.day.toString().padLeft(2, '0')}/${dataSelecionada!.month.toString().padLeft(2, '0')}/${dataSelecionada!.year.toString()}'
                    : '',
              ),
            ),
            const SizedBox(height: 16),
            // Seleção de horário inicial
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Horário Inicial',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
              readOnly: true,
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    horarioInicioSelecionado = picked;
                    _calcularValorTotal();
                  });
                }
              },
              controller: TextEditingController(
                text: horarioInicioSelecionado != null
                    ? horarioInicioSelecionado!.format(context)
                    : '',
              ),
            ),
            const SizedBox(height: 16),
            // Seleção de horário de fim
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Horário de Fim',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
              readOnly: true,
              onTap: () async {
                if (horarioInicioSelecionado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Selecione primeiro o horário inicial'),
                    ),
                  );
                  return;
                }

                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: horarioInicioSelecionado!.hour + 1,
                    minute: horarioInicioSelecionado!.minute,
                  ),
                );

                if (picked != null) {
                  // Verifica se o horário de fim é depois do início
                  if (picked.hour < horarioInicioSelecionado!.hour ||
                      (picked.hour == horarioInicioSelecionado!.hour &&
                          picked.minute <= horarioInicioSelecionado!.minute)) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'O horário de fim deve ser após o horário inicial',
                        ),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    horarioFimSelecionado = picked;
                    _calcularValorTotal();
                  });
                }
              },
              controller: TextEditingController(
                text: horarioFimSelecionado != null
                    ? horarioFimSelecionado!.format(context)
                    : '',
              ),
            ),
            const SizedBox(height: 16),
            // Exibição da duração e valor
            if (duracaoHoras > 0)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Duração: $duracaoHoras hora${duracaoHoras > 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Valor Total: R\$${valorTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (quadraSelecionada == null ||
                    dataSelecionada == null ||
                    horarioInicioSelecionado == null ||
                    horarioFimSelecionado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos')),
                  );
                  return;
                }
                // Simulação de agendamento bem-sucedido
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Agendamento realizado para $quadraSelecionada\n'
                      'Data: ${dataSelecionada!.day.toString().padLeft(2, '0')}/${dataSelecionada!.month.toString().padLeft(2, '0')}/${dataSelecionada!.year.toString()}\n'
                      'Horário: ${horarioInicioSelecionado!.format(context)} - ${horarioFimSelecionado!.format(context)}\n'
                      'Valor: R\$${valorTotal.toStringAsFixed(2)}',
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("CONFIRMAR AGENDAMENTO"),
            ),
          ],
        ),
      ),
    );
  }

  void _calcularValorTotal() {
    if (quadraSelecionada == null ||
        horarioInicioSelecionado == null ||
        horarioFimSelecionado == null) {
      setState(() {
        duracaoHoras = 0;
        valorTotal = 0.0;
      });
      return;
    }

    final inicio = horarioInicioSelecionado!;
    final fim = horarioFimSelecionado!;

    // Calcula a duração em horas (considera a diferença em minutos)
    final totalMinutos =
        (fim.hour - inicio.hour) * 60 + (fim.minute - inicio.minute);

    // Considera a duração em horas inteiras, arredondando para cima
    int horas = (totalMinutos / 60).ceil();

    if (horas <= 0) {
      setState(() {
        duracaoHoras = 0;
        valorTotal = 0.0;
      });
      return;
    }

    final precoPorHora = widget.precosQuadras[quadraSelecionada]!;
    final valor = horas * precoPorHora;

    setState(() {
      duracaoHoras = horas;
      valorTotal = valor;
    });
  }
}
