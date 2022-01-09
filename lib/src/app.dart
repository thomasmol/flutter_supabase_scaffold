import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'authentication/forgot_password_view.dart';
import 'authentication/login_view.dart';
import 'authentication/password_reset_view.dart';
import 'authentication/registration_view.dart';
import 'authentication/welcome_view.dart';
import 'home_view.dart';
import 'splash_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;
  final String initRoute = SplashView.routeName;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.teal,
              appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  elevation: 0,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.transparent)),
          darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.teal,
              primaryColor: Colors.teal.shade50,
              appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  elevation: 0,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent)),
          themeMode: settingsController.themeMode,
          initialRoute: initRoute,
          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case LoginView.routeName:
                    return const LoginView();
                  case RegistrationView.routeName:
                    return const RegistrationView();
                  case ForgotPasswordView.routeName:
                    return const ForgotPasswordView();
                  case PasswordResetView.routeName:
                    return const PasswordResetView();
                  case HomeView.routeName:
                    return const HomeView();
                  case WelcomeView.routeName:
                    return const WelcomeView();
                  case SplashView.routeName:
                  default:
                    return const SplashView();
                }
              },
            );
          },
        );
      },
    );
  }
}
