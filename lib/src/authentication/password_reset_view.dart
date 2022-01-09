import 'package:flutter/material.dart';
import '../home_view.dart';
import '../utils/auth_state.dart';
import '../utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordResetView extends StatefulWidget {
  const PasswordResetView({Key? key})
      : super(key: key);

  static const String routeName = '/password/reset';

  @override
  _PasswordResetViewState createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends AuthState<PasswordResetView> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();

  void _updatePassword() async {
    var t = AppLocalizations.of(context)!;
    late String accessToken = '';
    setState(() {
      _isLoading = true;
    });
    if (supabase.auth.session()?.accessToken != null) {
      accessToken = supabase.auth.session()!.accessToken;
    }
    final response = await supabase.auth.api.updateUser(
        accessToken, UserAttributes(password: _passwordTextController.text));
    final error = response.error;
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.authPasswordChangedMessage)));
      Navigator.of(context).pushReplacementNamed(HomeView.routeName);
    }

    setState(() {
      _isLoading = false;
    });
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
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 10),
                            child: Text(t.authPasswordReset,
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
                              obscureText: true,
                              controller: _passwordTextController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              decoration: InputDecoration(
                                  labelText: t.authPasswordReset),
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
                                        _updatePassword();
                                      }
                                    },
                                    child: Text(
                                      t.authResetPasswordButton,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                )
                              : const CircularProgressIndicator(),
                        ],
                      )),
                ))));
  }
}
