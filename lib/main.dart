import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shagun_resort_review/Screens/Login%20Screen/login_screen.dart';
import 'package:shagun_resort_review/utils/app_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Provider/authenticate_provider.dart';
import 'Screens/Booking Status/booking_status.dart';

  void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails errorDetails){
    assert((){
      return kDebugMode;
    }());
    if(kDebugMode){
      return ErrorWidget(errorDetails.exception);
    }
    return Container(
      alignment: Alignment.center,
      child: Text('Error\n${errorDetails.exception}',
      style: const TextStyle(color: Colors.orangeAccent,
      fontWeight: FontWeight.bold,
      ),
        textAlign: TextAlign.center,
      ),
    );
  };
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
   runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuth();
  }

  /// Check user logged in or not
  void checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    });
  }
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black
    ));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shagun Resort Review',
          onGenerateRoute: RouteGenerator.generateRoute,
          home: isLoggedIn ? const BookingStatus() : const LoginScreen()
        )
    );
  }
}


