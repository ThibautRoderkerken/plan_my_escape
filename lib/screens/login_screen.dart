import 'package:flutter/material.dart';
import '../widgets/custom_action_button.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_text_field.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Connexion',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          const CustomTextField(label: 'Email'),
          const SizedBox(height: 16),
          const CustomTextField(label: 'Password', isObscure: true),
          const SizedBox(height: 16),
          CustomActionButton(
            label: 'Connexion',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
              );
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
    );
  }
}
