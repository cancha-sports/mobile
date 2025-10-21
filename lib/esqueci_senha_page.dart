import 'package:flutter/material.dart';

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
