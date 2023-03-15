import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fyp2_system/auth/forget_pass.dart';
import 'package:fyp2_system/auth/login_sc.dart';
import 'package:fyp2_system/auth/register_sc.dart';
import 'package:fyp2_system/consts/theme_data.dart';
import 'package:fyp2_system/fetch_data.dart';
import 'package:fyp2_system/inner_screens/categoryprod_sc.dart';
import 'package:fyp2_system/inner_screens/discountedviewall_sc.dart';
import 'package:fyp2_system/providers/cart_provider.dart';
import 'package:fyp2_system/providers/order_provider.dart';
import 'package:fyp2_system/providers/products_provider.dart';
import 'package:fyp2_system/providers/viewed_provider.dart';
import 'package:fyp2_system/providers/wishlist_provider.dart';
import 'package:fyp2_system/screens/account_sc.dart';
import 'package:fyp2_system/widgets/featuredprod_widget.dart';
import 'package:fyp2_system/inner_screens/featured_sc.dart';
import 'package:fyp2_system/inner_screens/product_details.dart';
import 'package:fyp2_system/screens/onboarding_screen.dart';
import 'package:fyp2_system/providers/dark_theme_provider.dart';
import 'package:fyp2_system/screens/orders/orders_sc.dart';
import 'package:fyp2_system/screens/viewed_recently/viewed_recently.dart';
import 'package:fyp2_system/screens/whishlist/whishtlist_sc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

const AndroidNotificationChannel channel =
    AndroidNotificationChannel('high_importance_channed', 'name',
        //  'description',
        importance: Importance.high,
        playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/*Future<void> _firebaseMessagingBanckgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A message just showed:' '${message.messageId}');
}*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51MfTu1KK6QmEe7qyV0XQoTc42bFBdfx7qTA9blKXKRufgZeA0f1GbH5eM8xWD1GssXHJZaBulRHWZE6hW6qDn6r600qmLqhhNH";
  Stripe.instance.applySettings();
  await Firebase.initializeApp();
  await GetStorage.init();
  // await FirebaseMessaging.instance.getInitialMessage();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme = await themeChangeProvider.darkThemePrefs
        .getTheme(
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
    /*FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  color: Colors.black,
                  playSound: true,
                  icon: '@mipmap/ic_launcher'),
            ));
      }
    });*/

    /*  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('a new was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                  title: Text(notification.title!),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.body!),
                      ],
                    ),
                  ));
            });
      }
    });*/
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: SpinKitCubeGrid(color: Colors.black),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text('An error has occured'),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(
                create: (_) => ProductsProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => WishlistProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ViewedProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => OrdersProvider(),
              ),
            ],
            child: Consumer<DarkThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                  //remove logo
                  debugShowCheckedModeBanner: false,
                  theme: Styles.themeData(
                    themeProvider.getDarkTheme,
                    context,
                    const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                    ),
                  ),
//start here
                  home: SplashScreen(),

                  routes: {
                    discountvallSc.routeName: (ctx) => discountvallSc(),
                    FeedsWidget.routeName: (ctx) => FeedsWidget(),
                    ProductDetails.routeName: (ctx) => ProductDetails(),
                    WishlistSc.routeName: (ctx) => WishlistSc(),
                    OrdersSc.routeName: (ctx) => OrdersSc(),
                    ViewedRecentlySc.routeName: (ctx) => ViewedRecentlySc(),
                    FeedsScreen.routeName: (ctx) => FeedsScreen(),
                    RegisterSc.routeName: (ctx) => RegisterSc(),
                    LoginSc.routeName: (ctx) => LoginSc(),
                    CategoryprodSc.routeName: (ctx) => CategoryprodSc(),
                    ForgetPasswordScreen.routeName: (ctx) =>
                        ForgetPasswordScreen(),
                    AccountSc.routeName: (ctx) => AccountSc(),
                  },
                );
              },
            ),
          );
        });
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final save = GetStorage();

  @override
  void initState() {
    Timer(
      const Duration(seconds: 3), //will only show for 3 sec for users
      () {
        //read getstorage to find if the splash screen has already been displayed first
        bool? boardingsc = save.read('onboarding');
        boardingsc == null
            ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                return onboardSc();
              }))
            : boardingsc == true
                ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return fetchSc();
                  }))
                : Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return onboardSc();
                  }));
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    return Scaffold(
      body: Center(child: Image.asset('lib/assets/images/Logoxbg.png') //logo
          ),
    );
  }
}
