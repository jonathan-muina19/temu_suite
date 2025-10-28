import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../screens/email_verify_screen.dart';
import '../screens/home_screen.dart';
import '../screens/main_drawer.dart';
import '../screens/onboarding/onboarding_two.dart';
import '../screens/onboarding_screen.dart';
import '../screens/register_screen.dart';
import '../screens/splash_screen.dart';

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/homescreen':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case '/email-verify':
        return MaterialPageRoute(builder: (_) => EmailVerifyScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/onboardingtwo':
        return MaterialPageRoute(builder: (_) => OnboardingTwo());
      case '/mainwrapper':
        return MaterialPageRoute(builder: (_) => MainWrapper());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('Page non trouvee : ${routeSettings.name}'),
                ),
              ),
        );
    }
  }
}
