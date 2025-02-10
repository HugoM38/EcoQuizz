import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecoquizz/ui/widgets/EcoQuizz_appbar.dart';
import 'package:ecoquizz/ui/widgets/EcoQuizz_button.dart';
import 'login_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

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
                      'Connexion à EcoQuizz',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: viewModel.emailController,
                      decoration: InputDecoration(
                        labelText: "Adresse email",
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: viewModel.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    EcoQuizzButton(
                      title: "Se connecter",
                      isLoading: viewModel.isLoading,
                      isEnable: viewModel.isEnableLoginButton(),
                      onPressed: () async {
                        await viewModel.login(context);
                      },
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/signup'),
                      child: const Text(
                          "Vous n'avez pas de compte ? Inscrivez-vous"),
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
