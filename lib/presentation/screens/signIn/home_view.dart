import 'package:andromarkets/presentation/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/home_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context, AuthViewModel authViewModel) {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    authViewModel.login(email, password, context);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged out")),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: authViewModel.isLoading
            ? const CircularProgressIndicator()
            : user == null
            ? _buildLoginForm(context, authViewModel)
            : FutureBuilder(
          future: viewModel.loadUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (viewModel.user != null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('👤 ID: ${viewModel.user!.id}'),
                  Text('📛 Name: ${viewModel.user!.name}'),
                  Text('📧 Email: ${viewModel.user!.email}'),
                ],
              );
            } else {
              return const Text('No user data found. Please login.');
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthViewModel authViewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _handleLogin(context, authViewModel),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }


}
