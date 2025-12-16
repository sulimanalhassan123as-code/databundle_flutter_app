import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String API_URL = "https://never-hide17-dt3m.onrender.com";

void main() {
  runApp(const DataHubApp());
}

class DataHubApp extends StatelessWidget {
  const DataHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DataHub',
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
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  String status = "";
  bool loading = false;

  Future<void> register() async {
    setState(() {
      loading = true;
      status = "Processing...";
    });

    try {
      final res = await http.post(
        Uri.parse("$API_URL/api/v1/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": phoneController.text,
          "password": passwordController.text
        }),
      );

      final data = jsonDecode(res.body);

      setState(() {
        status = data["message"] ?? data["detail"] ?? "Done";
      });
    } catch (e) {
      setState(() {
        status = "Network error";
      });
    }

    setState(() {
      loading = false;
    });
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
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : register,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("CREATE ACCOUNT"),
              ),
            ),
            const SizedBox(height: 20),
            Text(status, style: const TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
