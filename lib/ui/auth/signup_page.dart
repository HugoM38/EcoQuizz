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
      appBar: const EcoQuizzAppBar(title: "EcoQuizz"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double horizontalPadding =
              constraints.maxWidth > 600 ? constraints.maxWidth * 0.2 : 20;
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Créer un compte',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: viewModel.emailController,
                      decoration: InputDecoration(
                          labelText: "Adresse email",
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.secondary),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: viewModel.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Mot de passe",
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.secondary),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: viewModel.confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Confirmer le mot de passe",
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.secondary),
                    ),
                    const SizedBox(height: 20),
                    EcoQuizzButton(
                      title: "S'inscrire",
                      isLoading: viewModel.isLoading,
                      isEnable: viewModel.isEnableSignupButton(),
                      onPressed: () async {
                        await viewModel.signup(context);
                      },
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text(
                          "Vous avez déjà un compte ? Connectez-vous"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
