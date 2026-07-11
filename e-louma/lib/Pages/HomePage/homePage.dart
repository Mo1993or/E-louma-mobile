import 'package:E_louma/main.dart';
import 'package:animate_do/animate_do.dart';
import 'package:E_louma/Pages/HomePage/ShopPage.dart';
import 'package:E_louma/Pages/client/client_discover_page.dart';
import 'package:E_louma/Pages/Auth/signup_page.dart';
import 'package:E_louma/models/user_role.dart';
import 'package:E_louma/services/session_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _readToken();
  }

  String token = "";
  _readToken() async {
    final prefs = await SharedPreferences.getInstance();
    await FirebaseMessaging.instance.requestPermission();

    var tokenValue = prefs.getString('token') ?? "";
    setState(() {
      token = tokenValue;
      print("tokenValue $token");
    });
  }

  Future<void> _continueAs(UserRole role) async {
    if (token.isEmpty) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: ClientDiscoverPage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: ShopPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash.png'),
                fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
            Colors.black.withOpacity(.9),
            Colors.black.withOpacity(.4),
          ])),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FadeInUp(
                      duration: Duration(milliseconds: 1300),
                      child: Text(
                        "Bienvenue sur",
                        style: TextStyle(
                            color: Colors.grey.shade300, fontSize: 22),
                      )),
                  FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "E-louma",
                        style: TextStyle(
                            color: Colors.white,
                            height: 1.2,
                            fontSize: 40,
                            fontWeight: FontWeight.w900),
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  FadeInUp(
                      duration: Duration(milliseconds: 1300),
                      child: Text(
                        "Votre marketplace pour acheter, vendre et faire de bonnes affaires au quotidien.",
                        style: TextStyle(
                            color: Colors.grey.shade300, fontSize: 22),
                      )),
                  SizedBox(
                    height: 36,
                  ),
                  // FadeInUp(
                  //   duration: Duration(milliseconds: 1500),
                  //   child: Text(
                  //     "Vous êtes ?",
                  //     style: TextStyle(
                  //       color: Colors.white70,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 12),
                  // FadeInUp(
                  //   duration: Duration(milliseconds: 1600),
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     height: 52,
                  //     child: FilledButton(
                  //       style: FilledButton.styleFrom(
                  //         backgroundColor: Colors.white,
                  //         foregroundColor: Colors.black,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(50),
                  //         ),
                  //       ),
                  //       onPressed: () => _continueAs(UserRole.client),
                  //       child: Text(
                  //         "Je suis client",
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 15,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 14),
                  FadeInUp(
                    duration: Duration(milliseconds: 1700),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () => _continueAs(UserRole.client),
                        child: Text(
                          (token.isEmpty)
                              ? "Commencer"
                              : "J'accède à mon compte",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()),
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Text(
                              "Créer un compte",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
