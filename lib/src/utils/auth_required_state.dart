import 'package:flutter/material.dart';
import '../splash_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRequiredState<T extends StatefulWidget>
    extends SupabaseAuthRequiredState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      /// Users will be sent back to the splash page if they sign out.
      Navigator.of(context).pushNamedAndRemoveUntil(SplashView.routeName, (route) => false);
    }
  }
}