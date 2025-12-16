import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String API_BASE = "https://never-hide17-dt3m.onrender.com";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Data Bundle Hub',
      theme: ThemeData.dark(),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String status = "";
  bool loading = false;

  Future<void> register() async {
    setState(() {
      loading = true;
      status = "Connecting...";
    });

    try {
      final res = await http.post(
        Uri.parse("$API_BASE/api/v1/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": phoneCtrl.text.trim(),
          "password": passCtrl.text.trim(),
        }),
      );

      final data = jsonDecode(res.body);

      setState(() {
        status = data["detail"] ?? "Account created";
      });
    } catch (e) {
      setState(() {
        status = "Network error";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Data Bundle Hub",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: loading ? null : register,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("REGISTER"),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              status,
              style: const TextStyle(color: Colors.greenAccent),
            ),
          ],
        ),
      ),
    );
  }
}
