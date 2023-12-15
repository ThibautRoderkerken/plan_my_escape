import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/sign_up_view_model.dart';
import '../widgets/custom_action_button.dart';
import '../widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signUpViewModel = Provider.of<SignUpViewModel>(context);

    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: signUpViewModel.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Inscription',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: signUpViewModel.emailController,
                label: 'Email',
                validator: signUpViewModel.validateEmail,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: signUpViewModel.passwordController,
                label: 'Mot de passe',
                isObscure: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: signUpViewModel.firstNameController,
                label: 'Prénom',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: signUpViewModel.lastNameController,
                label: 'Nom',
              ),
              const SizedBox(height: 32),
              CustomActionButton(
                label: 'S\'inscrire',
                onPressed: () {
                  signUpViewModel.validateAndSignUp(() {
                    Navigator.pushNamed(context, '/dashboard');
                  });
                },
              ),
              if (signUpViewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    signUpViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
