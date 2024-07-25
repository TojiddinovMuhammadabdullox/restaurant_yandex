import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase_ui;
import 'package:restaurant_yandex/bloc/restorant_cubit.dart';
import 'package:restaurant_yandex/firebase_options.dart';
import 'package:restaurant_yandex/views/screens/home_screen.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final providers = [firebase_ui.EmailAuthProvider()];

    return BlocProvider(
      create: (context) => RestoranCubit(),
      child: MaterialApp(
        initialRoute:
            FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
        routes: {
          '/sign-in': (context) {
            return firebase_ui.SignInScreen(
              providers: providers,
              actions: [
                firebase_ui.AuthStateChangeAction<firebase_ui.SignedIn>(
                    (context, state) {
                  Navigator.pushReplacementNamed(context, '/home');
                }),
              ],
            );
          },
          '/home': (context) => const HomeScreen(),
        },
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (snapshot.hasData) {
                return const HomeScreen();
              } else {
                return firebase_ui.SignInScreen(
                  providers: providers,
                );
              }
            }
          },
        ),
      ),
    );
  }
}
