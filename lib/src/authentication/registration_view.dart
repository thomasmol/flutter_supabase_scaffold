import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../splash_view.dart';
import '../utils/auth_state.dart';
import '../utils/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({Key? key}) : super(key: key);
  static const String routeName = '/register';

  @override
  _RegistrationViewState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends AuthState<RegistrationView> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });
    final response = await supabase.auth.signUp(
        _emailTextController.text, _passwordTextController.text,
        options: AuthOptions(
            redirectTo: kIsWeb
                ? null
                : 'io.supabase.flutterscaffold://login-callback/'));
    final error = response.error;
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    } else {
      final responseProfile = await supabase.from('profiles').insert({
        'id': response.data?.user!.id,
        'first_name': _firstNameTextController.text,
        'last_name': _lastNameTextController.text
      }).execute();
      final error = responseProfile.error;
      if (error != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
    setState(() {
      _isLoading = false;
    });
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
                            child: Text(t.authRegisterViewMessage,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 10),
                            child: TextFormField(
                              autofocus: true,
                              controller: _firstNameTextController,
                              keyboardType: TextInputType.text,
                              autofillHints: const [AutofillHints.givenName],
                              textInputAction: TextInputAction.next,
                              decoration:
                                  InputDecoration(labelText: t.authFirstName),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return t.authInvalidNameMessage;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 10),
                            child: TextFormField(
                              controller: _lastNameTextController,
                              keyboardType: TextInputType.text,
                              autofillHints: const [AutofillHints.familyName],
                              textInputAction: TextInputAction.next,
                              decoration:
                                  InputDecoration(labelText: t.authLastName),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return t.authInvalidNameMessage;
                                }
                                return null;
                              },
                            ),
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
                                        _signUp();
                                      }
                                    },
                                    child: Text(
                                      t.authCreateAccountButton,
                                    ),
                                  ),
                                )
                              : const CircularProgressIndicator(),
                        ],
                      )),
                ))));
  }
}
