import 'package:E_louma/Pages/Auth/change_password.dart';
import 'package:E_louma/Pages/Auth/signIn.dart';
import 'package:E_louma/Utils/api_error.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/Utils/size.dart';
import 'package:E_louma/services/auth_service.dart';
import 'package:E_louma/widget/showAlertCustom.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class VerifyOtpPage extends StatefulWidget {
  final String email;
  final bool isCommingSignup;
  const VerifyOtpPage(
      {Key? key, required this.email, required this.isCommingSignup})
      : super(key: key);

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPagePageState();
}

class _VerifyOtpPagePageState extends State<VerifyOtpPage> {
  final _forgetPasswordFormKey = GlobalKey<FormState>();
  TextEditingController emailCtr = TextEditingController();
  String code = "";
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
                  PageHeading(
                    title: 'Vérification email',
                  ),
                  Container(
                      margin: EdgeInsets.all(20),
                      child: Text(
                        "Veuillez saisir le code envoyé à ce mail ${widget.email} ",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      )),
                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: primaryColor,
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: false,
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      setState(() {
                        code = code;
                      });
                      //handle validation or checks here
                    },
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) {
                      setState(() {
                        code = verificationCode;
                      });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Verification Code"),
                              content:
                                  Text('Code entered is $verificationCode'),
                            );
                          });
                    }, // end onSubmit
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomFormButton(
                    innerText: 'Valider',
                    onPressed: _handleVerifyEmail,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  _handleVerifyEmail() async {
    // forget password
    if (_forgetPasswordFormKey.currentState!.validate()) {
      try {
        showAlertDialog(context);

        var data = {"code": code};
        var result = await AuthService().verifyAccount(data);

        print("result $result");
        // setState(() {
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => ShopPage()));
        // });

        if (widget.isCommingSignup) {
          setState(() {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          });
        } else {
          setState(() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(
                          email: emailCtr.text,
                        )));
          });
        }
      } catch (error) {
        print("error $error");
        Navigator.pop(context);
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Erreur',
            message: cleanExceptionMessage(
              error,
              fallback: 'Une erreur est survenue',
            ),
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
