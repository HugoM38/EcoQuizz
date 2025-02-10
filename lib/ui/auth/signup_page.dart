import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecoquizz/ui/widgets/EcoQuizz_appbar.dart';
import 'package:ecoquizz/ui/widgets/EcoQuizz_button.dart';
import 'signup_viewmodel.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);

    return Scaffold(
      appBar: const EcoQuizzAppBar(title: "Inscription"),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.2,
                    vertical: 20),
                child: Text(
                  'Créer un compte',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.2,
                    vertical: 10),
                child: TextFormField(
                  controller: viewModel.emailController,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  decoration: InputDecoration(
                    labelText: "Addresse email",
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.2,
                    vertical: 10),
                child: TextFormField(
                  controller: viewModel.passwordController,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                  ),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.2,
                    vertical: 10),
                child: TextFormField(
                  controller: viewModel.confirmPasswordController,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                  ),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: EcoQuizzButton(
                  title: "S'inscrire",
                  isLoading: viewModel.isLoading,
                  isEnable: viewModel.isEnableSignupButton(),
                  onPressed: () async {
                    await viewModel.signup(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}