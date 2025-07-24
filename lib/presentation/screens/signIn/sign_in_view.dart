import 'package:andromarkets/config/theme/app_colors.dart';
import 'package:andromarkets/core/enums/textfield_type.dart';
import 'package:andromarkets/presentation/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/textFieldComponent.dart';
import '../../viewmodel/home_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {


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

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
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
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthViewModel authViewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFieldCom(
            label: 'Email Address',
            hintText: 'Enter email address',
            controller: emailController,
            prefixIcon: 'assets/icons/email.svg',
            // textFieldType: hasError ? TextFieldType.errorState : TextFieldType.defaultState,
            // errorText: hasError ? 'Show error Text Message From the API' : null,

          ),
          TextFieldCom(
            label: 'Password',
            hintText: 'Enter your password',
            controller: passwordController,
            isObscure: true,
            prefixIcon: 'assets/icons/password.svg',
            // textFieldType: hasError ? TextFieldType.errorState : TextFieldType.defaultState,
            // errorText: hasError ? 'Show error Text Message From the API' : null,
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
