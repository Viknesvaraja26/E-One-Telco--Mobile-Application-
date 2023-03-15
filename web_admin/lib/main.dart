import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:web_admin/innersc/add_prod.dart';
import 'package:web_admin/providers/dark_theme_provider.dart';
import 'package:web_admin/screens/Auth_Sc/auth_sc.dart';
import 'package:web_admin/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? FirebaseOptions(
              apiKey: "AIzaSyCXgkSUl8-AZC-NzSui-RgjOoku9u_Idxk",
              appId: "1:688200263234:web:68bba29428659ed27befdb",
              messagingSenderId: "688200263234",
              projectId: "telco-system-app",
              storageBucket: "telco-system-app.appspot.com",
            )
          : null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              )),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('An error occured'),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) {
                  return themeChangeProvider;
                },
              ),
            ],
            child: Consumer<DarkThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Admin Panel',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: auth_Sc(),
                  routes: {
                    UploadProductForm.routeName: (context) =>
                        UploadProductForm(),
                    MainScreen.routeName: (context) => MainScreen(),
                  },
                  builder: EasyLoading.init(),
                );
              },
            ),
          );
        });
  }
}
