import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_flutter/flavor.dart';
import 'package:todo_flutter/my_app.dart';
import 'package:todo_flutter/providers/auth_provider.dart';
import 'package:todo_flutter/providers/language_provider.dart';
import 'package:todo_flutter/providers/theme_provider.dart';
import 'package:todo_flutter/services/firestore_database.dart';
import 'package:firebase_core/firebase_core.dart';  // Import Firebase Core
import 'package:provider/provider.dart';

void main() async {
  // Ensure Widgets are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();

  // Set the preferred orientations for the app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          Provider<Flavor>.value(value: Flavor.dev),
          ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(),
          ),
          ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider(),
          ),
          ChangeNotifierProvider<LanguageProvider>(
            create: (context) => LanguageProvider(),
          ),
        ],
        child: MyApp(
          databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
          key: Key('MyApp'),
        ),
      ),
    );
  });
}
