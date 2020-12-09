import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/AddSignScreen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/TrafficSignDetail.dart';
import './screens/main_screen.dart';
import './providers/auth.dart';
import './providers/signsScanned.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ScannedSigns>(
          create: (_) => ScannedSigns(null, null, []),
          update: (ctx, auth, previousSigns) {
            return ScannedSigns(
              auth.token,
              auth.userID,
              previousSigns == null ? [] : previousSigns.items,
            );
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            title: 'Traffic Sign App',
            theme: ThemeData(
                primarySwatch: Colors.indigo,
                accentColor: Colors.amber,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {})),
            home: auth.isAuth
                ? MainScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              AddSignScreen.routeName: (ctx) => AddSignScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
              TrafficSignDetail.routeName: (ctx) => TrafficSignDetail(),
            }),
      ),
    );
  }
}
