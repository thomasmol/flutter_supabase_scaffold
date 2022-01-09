import 'package:flutter/material.dart';
import 'utils/auth_state.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  static const String routeName = '/splash';

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends AuthState<SplashView> {
  @override
  void initState() {
    recoverSupabaseSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
