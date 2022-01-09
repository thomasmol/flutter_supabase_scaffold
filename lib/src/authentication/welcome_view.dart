import 'package:flutter/material.dart';
import '../utils/auth_state.dart';
import 'forgot_password_view.dart';
import 'login_view.dart';
import 'registration_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  static const String routeName = '/welcome';

  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends AuthState<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 36),
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                height: 50,
              ),
            ),
             Padding(
              padding:const EdgeInsets.fromLTRB(36, 10, 36, 120),
              child: Text(t.appTitle,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 10, 36, 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    Navigator.of(context).pushNamed(RegistrationView.routeName);
                  },
                  child: Text(
                      t.authCreateAccountButton)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 10, 36, 10),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    Navigator.of(context).pushNamed(LoginView.routeName);
                  },
                  child: Text(t.authLoginButton)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 10, 36, 20),
              child: TextButton(
                  style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(ForgotPasswordView.routeName);
                  },
                  child: Text(t.authTroubleSigningInButton)),
            ),
          ],
        ),
      ),
    );
  }
}
