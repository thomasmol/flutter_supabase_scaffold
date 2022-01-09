import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../splash_view.dart';
import '../utils/auth_state.dart';
import 'forgot_password_view.dart';
import '../utils/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends AuthState<LoginView> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    final response = await supabase.auth.signIn(
        email: _emailTextController.text,
        password: _passwordTextController.text);
    final error = response.error;
    setState(() {
      _isLoading = false;
    });
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
      return;
    }
    Navigator.of(context).pushReplacementNamed(SplashView.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: AutofillGroup(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 20),
                            child: SvgPicture.asset(
                              'assets/images/logo.svg',
                              semanticsLabel: 'Logo',
                              height: 60,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 10),
                            child: Text(t.authLoginViewMessage,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 10),
                            child: TextFormField(
                              controller: _emailTextController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.email,
                                AutofillHints.username
                              ],
                              decoration:
                                  InputDecoration(labelText: t.authEmail),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !EmailValidator.validate(value)) {
                                  return t.authInvalidEmailMessage;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 10),
                            child: TextFormField(
                              controller: _passwordTextController,
                              obscureText: true,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              decoration:
                                  InputDecoration(labelText: t.authPassword),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 8) {
                                  return t.authInvalidPasswordMessage;
                                }
                                return null;
                              },
                            ),
                          ),
                          !_isLoading
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 36.0, vertical: 20),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(50)),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _signIn();
                                      }
                                    },
                                    child: Text(
                                      t.authLoginButton,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                )
                              : const CircularProgressIndicator(),
                          TextButton(
                              onPressed: () => {
                                    Navigator.of(context).pushReplacementNamed(
                                        ForgotPasswordView.routeName)
                                  },
                              child: Text(t.authTroubleSigningInButton))
                        ],
                      )),
                ))));
  }
}
