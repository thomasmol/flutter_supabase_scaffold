import 'package:flutter/material.dart';
import '../authentication/password_reset_view.dart';
import '../authentication/welcome_view.dart';
import '../home_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(WelcomeView.routeName, (route) => false);
    }
  }

  @override
  void onAuthenticated(Session session) {
    if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeView.routeName, (route) => false);
    }
  }

  @override
  void onPasswordRecovery(Session session) {
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          PasswordResetView.routeName, (route) => false);
    }
  }

  @override
  void onErrorAuthenticating(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
