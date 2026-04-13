import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../services/auth_service.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/primary_button.dart';

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
        final role = await AuthService.getRole();

        if (!mounted) return;

        if (role == "admin") {
          context.go("/admin");
        } else {
          context.go("/home");
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Login",
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
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

              PrimaryButton(text: "Login", icon: Icons.login, onPressed: login),

              TextButton(
                onPressed: () => context.go("/signup"),
                child: const Text("Create Account"),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => context.go("/panic"),
                icon: const Icon(Icons.warning),
                label: const Text("Emergency SOS"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
