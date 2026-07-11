import 'package:E_louma/Pages/Auth/change_password.dart';
import 'package:E_louma/Pages/Auth/verify_otp.dart';
import 'package:E_louma/Pages/Auth/signIn.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/Utils/size.dart';
import 'package:E_louma/services/auth_service.dart';
import 'package:E_louma/widget/showAlertCustom.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _forgetPasswordFormKey = GlobalKey<FormState>();
  TextEditingController emailCtr = TextEditingController();
  _readEmail() async {
    final prefs = await SharedPreferences.getInstance();

    var emailValue = prefs.getString('email') ?? "";
    setState(() {
      emailCtr.text = emailValue;
      print("emailValue $emailValue");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
              Colors.black.withOpacity(.8),
              Colors.black.withOpacity(.2),
            ])),
            child: PageHeader()),
        Container(
            margin: EdgeInsets.only(top: 60, left: 25),
            alignment: Alignment.topLeft,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Center(
                      child: Icon(
                    Icons.arrow_back_ios,
                    color: primaryColor,
                  ))),
            )),
        Container(
          margin: EdgeInsets.only(top: mediaHeight(context) / 2.3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _forgetPasswordFormKey,
              child: Column(
                children: [
                  const PageHeading(
                    title: 'Mot de passe oublié',
                  ),
                  CustomInputField(
                    labelText: 'Email',
                    hintText: 'Votre mail',
                    isDense: true,
                    validator: (textValue) {
                      if (textValue == null || textValue.isEmpty) {
                        return 'Email obligatoire !';
                      }
                      // if(!EmailValidator.validate(textValue)) {
                      //   return 'Please enter a valid email';
                      // }
                      return null;
                    },
                    emailCtr: emailCtr,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomFormButton(
                    innerText: 'Valider',
                    onPressed: _handleForgetPassword,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()))
                      },
                      child: const Text(
                        'Retour',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff939393),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  _handleForgetPassword() async {
    // forget password
    if (_forgetPasswordFormKey.currentState!.validate()) {
      try {
        showAlertDialog(context);

        var data = {"email": emailCtr.text};
        var result = await AuthService().forgotPassword(data);

        print("result $result");
        // setState(() {
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => ShopPage()));
        // });

        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyOtpPage(
                        email: emailCtr.text,
                        isCommingSignup: false,
                      )));
        });
      } catch (error) {
        print("error $error");
        Navigator.pop(context);
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Erreur',
            message: 'Identifiants invalide',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }
  }
}
