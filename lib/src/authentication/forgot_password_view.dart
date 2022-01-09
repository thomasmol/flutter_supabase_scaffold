import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/auth_state.dart';
import '../utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  static const String routeName = '/password/forgot';

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends AuthState<ForgotPasswordView> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();

  void _sendPasswordResetLink() async {
    setState(() {
      _isLoading = true;
    });
    final response = await supabase.auth.api.resetPasswordForEmail(
        _emailTextController.text,
        options: AuthOptions(
            redirectTo: kIsWeb
                ? null
                : 'io.supabase.flutterscaffold://reset-callback/'));
    final error = response.error;
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!
              .authPasswordResetCheckInboxMessage(_emailTextController.text))));
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
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
                            child: Text(t.authForgotPasswordMessage,
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
                              controller: _emailTextController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
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
                          !_isLoading
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 36.0, vertical: 20),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(50)),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _sendPasswordResetLink();
                                      }
                                    },
                                    child: Text(
                                      t.authSendResetLinkButton,
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
