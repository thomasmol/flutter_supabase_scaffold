import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'],
      anonKey: dotenv.env['SUPBASE_ANON_KEY'],
      authCallbackUrlHostname: 'login-callback');
  await SupabaseAuth.initialize(authCallbackUrlHostname: 'reset-callback');

  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();

  runApp(MyApp(settingsController: settingsController));
}
