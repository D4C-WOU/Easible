import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  void login() async {
    try {
      final res = await ApiService.post("/auth/login", {
        "email": emailCtrl.text.trim(),
        "password": passCtrl.text.trim(),
      });

      if (res.containsKey("access_token")) {
        await StorageService.saveToken(res["access_token"]);

        if (!mounted) return;
        context.go("/home");
      } else {
        throw Exception("Invalid credentials");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Easible Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Login")),
            TextButton(
              onPressed: () => context.go("/signup"),
              child: const Text("Create Account"),
            ),

            const Spacer(),

            // 🚨 Emergency Bypass
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => context.go("/panic"),
              icon: const Icon(Icons.warning),
              label: const Text("Emergency SOS"),
            ),
          ],
        ),
      ),
    );
  }
}
