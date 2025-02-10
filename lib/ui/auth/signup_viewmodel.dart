import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ecoquizz/services/auth_service.dart';
import 'package:ecoquizz/utils/show_error_snackbar.dart';

class SignupViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  SignupViewModel() {
    emailController.addListener(_onFieldChanged);
    passwordController.addListener(_onFieldChanged);
    confirmPasswordController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.removeListener(_onFieldChanged);
    passwordController.removeListener(_onFieldChanged);
    confirmPasswordController.removeListener(_onFieldChanged);
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );
  final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9])[^\s]{8,}$',
  );

  Future signup(BuildContext context) async {
    if (!emailRegex.hasMatch(emailController.text)) {
      showErrorSnackbar(context, "Adresse email invalide");
      return;
    }

    if (!passwordRegex.hasMatch(passwordController.text)) {
      showErrorSnackbar(context,
          "Le mot de passe doit contenir au moins 8 caractères, une majuscule, une minuscule et un chiffre");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showErrorSnackbar(context, "Les mots de passe ne correspondent pas");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      Response response = await AuthService().signup(
        emailController.text,
        passwordController.text,
      );

      if (response.statusCode == 201) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      showErrorSnackbar(context, e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  bool isEnableSignupButton() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        !isLoading;
  }
}
