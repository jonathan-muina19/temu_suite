import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../widgets/MyscaffoldMessenger.dart';
import '../widgets/bottomsheetFormSignup.dart';
import '../widgets/bottomsheetFormSingin.dart';
import '../widgets/register_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _showBottomSheetSignup(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext contect) {
          return BottomsheetformSingup();
        },
      );
    }

    void _showBottomSheetSignin(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext contect) {
          return BottomsheetformSignin();
        },
      );
    }

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state){
        if(state is AuthFailure){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: MyScaffoldMessenger(
                title: 'Erreur',
                message: state.message,
                color: Colors.red,
                icon: Icon(Icons.error),
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 630),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
              backgroundColor: Colors.red,
              elevation: 20,
            ),
          );
        } else if(state is AuthSuccess){
          Navigator.pushReplacementNamed(context, '/mainwrapper');
        }
      },
      builder: (context, state){
        return Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                _degradeblanc(context),
                const SizedBox(height: 10),
                _registerTitle(context),
                _subTitleRegister(context),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Divider(),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                RegisterButton(
                  onTap: (){
                    //context.read<AuthBloc>().add(SignInWithGoogle());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: MyScaffoldMessenger(
                          title: 'Warning',
                          message: "Bientot disponible",
                          color: Colors.orange,
                          icon: Icon(Icons.warning_amber_outlined),
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 630),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 20,
                      ),
                    );
                  },
                  title: 'Continue avec Google',
                  color: Colors.white.withOpacity(0.0),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                  imagePath: 'assets/icons/google.png',
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        indent: 20,
                        endIndent: 10,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Ou s'inscrire avec",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        indent: 20,
                        endIndent: 10,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RegisterButton(
                  onTap: () => _showBottomSheetSignup(context),
                  title: 'Inscription avec Email',
                  color: Colors.black,
                  imagePath: 'assets/icons/envelope.png',
                  textColor: Colors.white,
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: 'Vous avez un compte? ',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Se connecter',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                        recognizer:
                        TapGestureRecognizer()
                          ..onTap = () => _showBottomSheetSignin(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

// Le degrade blanc entre l'image et les composants
Widget _degradeblanc(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.5, // 50% de l'écran
    child: Stack(
      children: [
        // Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/registerImg.jpg',
            fit: BoxFit.cover,
          ),
        ),
        // Dégradé blanc en bas de l’image
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white.withOpacity(0.9), // haut (blanc visible)
                  Colors.white.withOpacity(0.0), // vers transparent
                ],
                stops: [0.1, 0.4], // contrôle la zone du dégradé
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// Le titre de la page RegisterScreen
Widget _registerTitle(BuildContext context) {
  return Center(
    child: Text(
      'Welcome back👋',
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'Montserrat',
        fontSize: 23,
      ),
    ),
  );
}

// sous titre du RegisrerScreen
Widget _subTitleRegister(BuildContext context) {
  return Center(
    child: Text(
      'Les meilleures recettes de cuisine et de\n repas africain',
      style: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
