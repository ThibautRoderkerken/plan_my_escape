import 'package:flutter/material.dart';
import '../widgets/custom_action_button.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_text_field.dart';
import 'dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ ne peut pas être vide';
    }
    if (!value.contains('@')) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Connexion',
                key: Key('login_screen_title'),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: emailController,
                label: 'Email',
                key: const Key('login_screen_email_field'),
                validator: emailValidator,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                label: 'Password',
                isObscure: true,
                key: Key('login_screen_password_field'),
              ),
              const SizedBox(height: 16),
              CustomActionButton(
                label: 'Connexion',
                key: const Key('login_screen_login_button'),
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardMainScreen(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomOutlinedButton(
                label: 'S\'authentifier via OAuth2',
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
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
