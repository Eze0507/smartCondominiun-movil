import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/perfil_page.dart';
import 'pages/editar_perfil_page.dart';
import 'pages/cambiar_password_page.dart';
import 'pages/reconocimiento_facial_page.dart';
import 'pages/expensas_page.dart';
import 'pages/objetos_perdidos_page.dart';
import 'services/fcm_service.dart';
import 'config/stripe_config.dart';

// Handler para mensajes en segundo plano
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Mensaje recibido en segundo plano: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Configurar handler de mensajes en segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Inicializar servicio FCM
  await FCMService.initialize();
  
  // Inicializar Stripe
  Stripe.publishableKey = StripeConfig.publishableKey;
  Stripe.merchantIdentifier = 'merchant.com.smartcondominium';
  await Stripe.instance.applySettings();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: "/",
      routes: {
        "/": (context) =>
            LoginPage(onToggleTheme: _toggleTheme, isDark: _isDark),
        "/perfil": (context) =>
            PerfilPage(onToggleTheme: _toggleTheme, isDark: _isDark),
        "/editar-perfil": (context) => const EditarPerfilPage(),
        "/cambiar-password": (context) => const CambiarPasswordPage(),
        "/reconocimiento-facial": (context) =>
            ReconocimientoFacialPage(onToggleTheme: _toggleTheme, isDark: _isDark),
        "/expensas": (context) =>
            ExpensasPage(onToggleTheme: _toggleTheme, isDark: _isDark),
        "/objetos-perdidos": (context) =>
            ObjetosPerdidosPage(onToggleTheme: _toggleTheme, isDark: _isDark),
      },
    );
  }
}
