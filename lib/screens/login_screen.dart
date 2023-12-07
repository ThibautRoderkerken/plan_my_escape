import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/dashboard/dashboard_view_model.dart';
import '../view_models/login_view_model.dart';
import '../widgets/custom_action_button.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_text_field.dart';
import 'dashboard/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: loginViewModel.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Connexion',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: loginViewModel.emailController,
                label: 'Email',
                validator: loginViewModel.validateEmail,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: loginViewModel.passwordController,
                label: 'Password',
                isObscure: true,
              ),
              const SizedBox(height: 16),
              CustomActionButton(
                label: 'Connexion',
                onPressed: () {
                  // Récupération des valeurs email et password
                  String email = loginViewModel.emailController.text;
                  String password = loginViewModel.passwordController.text;

                  loginViewModel.validateAndLogin(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => DashboardViewModel(),
                          child: DashboardMainScreen(),
                        ),
                      ),
                    );
                  }, email, password);
                },
              ),

              const SizedBox(height: 16),
              CustomOutlinedButton(
                label: 'S\'authentifier via OAuth2',
                onPressed: () => loginViewModel.authenticateWithOAuth(context),
              ),
              if (loginViewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    loginViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => loginViewModel.navigateToSignUp(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                child: const Text('Créer un compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
