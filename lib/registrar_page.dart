import 'package:flutter/material.dart';
import 'api_config.dart';
import 'api_service.dart';

class TelaRegistrar extends StatelessWidget {
  const TelaRegistrar({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController birthController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();

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
                labelText: "Nome completo",
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
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Telefone",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: birthController, // ADICIONE ESTE CONTROLLER
              decoration: const InputDecoration(
                labelText: "Data de nascimento",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(
                    const Duration(days: 365 * 18),
                  ),
                  firstDate: DateTime(DateTime.now().year - 120),
                  lastDate: DateTime.now().subtract(
                    const Duration(days: 365 * 18),
                  ),
                );
                if (picked != null) {
                  String formattedDate =
                      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                  birthController.text = formattedDate;
                }
              },
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

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ApiService.post(ApiConfig.register, {
                    'name': nomeController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'birth_date': birthController.text,
                    'password': senhaController.text,
                    'role_id': 2,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Registro realizado para ${emailController.text}',
                      ),
                    ),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro no registro: $e')),
                  );
                }
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
