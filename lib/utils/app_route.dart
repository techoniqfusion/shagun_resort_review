import 'package:flutter/material.dart';
import 'package:shagun_resort_review/Screens/Login%20Screen/login_screen.dart';
import '../Screens/Booking Status/booking_status.dart';

class RouteGenerator{

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
      // case "/" :
      //   return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppScreen.login :
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppScreen.bookingStatus :
        return MaterialPageRoute(builder: (_) => const BookingStatus());
    }
    return _errorRoute();
  }
  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(appBar: AppBar(title: const Text("Error"),),
        body: const Center(
          child: Text("something went wrong"),
        ),
      );
    });
  }
}


class AppScreen{
  static const String login = "login";
  static const String bookingStatus = "booking status";
}