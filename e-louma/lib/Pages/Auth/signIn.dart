import 'package:E_louma/Pages/Auth/forgotPassword.dart';
import 'package:E_louma/Pages/HomePage/ShopPage.dart';
import 'package:E_louma/Pages/Auth/signup_page.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/models/user_role.dart';
import 'package:E_louma/services/auth_service.dart';
import 'package:E_louma/services/session_service.dart';
import 'package:E_louma/Utils/size.dart';
import 'package:E_louma/widget/showAlertCustom.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //
  final _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();
  var fcmToken = "";

  _getTokenFirebase() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'tokenFirebase';
    var values = prefs.getString(key) ?? "";
    setState(() {
      fcmToken = values;
    });
  }

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
    _getTokenFirebase();
    _readEmail();
  }

  _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'email';
    var value = prefs.setString(key, email);
    debugPrint("value $value");
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Sanitize the number by removing white spaces if any exist
    final String cleanNumber = phoneNumber.replaceAll(' ', '');
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: cleanNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw Exception('Could not launch phone dialer for $cleanNumber');
    }
  }

  _handleLoginUser() async {
    if (_loginFormKey.currentState!.validate()) {
      try {
        showAlertDialog(context);

        var data = {
          "email": emailCtr.text,
          "password": passwordCtr.text,
          "fcmToken": fcmToken
        };
        var result = await AuthService().signIn(data);

        print("result $result");
        if (result["statusCode"] == 409) {
          Navigator.pop(context);
          QuickAlert.show(
            context: context,
            type: QuickAlertType.info,
            showConfirmBtn: true,
            showCancelBtn: true,
            confirmBtnText: 'Appelé',
            cancelBtnText: "Non",
            confirmBtnColor: primaryColor,
            title: "Compte désactivé",
            text: result["message"].toString(),
            onConfirmBtnTap: () async {
              await _makePhoneCall("+221773123189");
            },
          );
        } else {
          await _saveEmail(emailCtr.text);
          // setState(() {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ShopPage()));
          // });
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
            message: 'Identifiants invalide',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
      // UserRole? role = await _promptRoleIfNeeded();
      // role ??= UserRole.client;
      // await SessionService.setRole(role);
      // await SessionService.setLoggedIn(true);
      // if (!mounted) return;
      // if (role == UserRole.seller) {
      //   Navigator.pushReplacement(context,
      //       MaterialPageRoute(builder: (context) => const DashboardPage()));
      // } else {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (context) => ShopPage()));
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(begin: Alignment.bottomRight, colors: [
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
            margin: EdgeInsets.only(top: mediaHeight(context) / 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    const PageHeading(
                      title: 'Connexion',
                    ),
                    CustomInputField(
                      labelText: 'Email',
                      hintText: 'Votre email',
                      validator: (textValue) {
                        if (textValue == null || textValue.isEmpty) {
                          return 'Email obligatoire';
                        }

                        // if (!EmailValidator.validate(textValue)) {
                        //   return 'Please enter a valid email';
                        // }
                        return null;
                      },
                      emailCtr: emailCtr,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomInputFieldPassword(
                      labelText: 'Mot de passe',
                      hintText: 'Votre mot de passe',
                      obscureText: true,
                      suffixIcon: true,
                      validator: (textValue) {
                        if (textValue == null || textValue.isEmpty) {
                          return 'Mot de passe obligatoire!';
                        }
                        return null;
                      },
                      passwordCtr: passwordCtr,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: size.width * 0.80,
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPasswordPage()))
                        },
                        child: Text(
                          'Mot de passe oublié?',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(children: [
                      Center(
                          child: CustomFormButton(
                        innerText: 'Se connecter',
                        onPressed: _handleLoginUser,
                      )),
                    ]),
                    const SizedBox(
                      height: 18,
                    ),
                    SizedBox(
                      width: size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Pas encore de compte ? ',
                            style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff939393),
                                fontWeight: FontWeight.normal),
                          ),
                          GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignupPage()))
                            },
                            child: Text(
                              'Créer votre compte',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<UserRole?> _promptRoleIfNeeded() async {
    final existing = await SessionService.getRole();
    if (existing != null) return existing;
    if (!mounted) return null;
    return showDialog<UserRole>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Choisir votre profil'),
        content: const Text(
          'Aucun type de compte enregistré sur cet appareil. Que représentez-vous ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, UserRole.client),
            child: const Text('Client'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, UserRole.seller),
            child: const Text('Vendeur'),
          ),
        ],
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mediaWidth(context),
      height: mediaHeight(context) / 2,
      child: Image.asset(
        'assets/images/background.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}

class PageHeading extends StatelessWidget {
  final String title;
  const PageHeading({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 25),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'NotoSerif'),
      ),
    );
  }
}

class CustomInputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? emailCtr;
  final String? Function(String?) validator;
  final bool suffixIcon;
  final bool? isDense;
  final bool obscureText;

  const CustomInputField(
      {Key? key,
      required this.labelText,
      required this.hintText,
      required this.emailCtr,
      required this.validator,
      this.suffixIcon = false,
      this.isDense,
      this.obscureText = false})
      : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  //
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.labelText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            obscureText: (widget.obscureText && _obscureText),
            controller: widget.emailCtr,
            decoration: InputDecoration(
              isDense: (widget.isDense != null) ? widget.isDense : false,
              hintText: widget.hintText,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryColor)),
              suffixIcon: widget.suffixIcon
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.remove_red_eye
                            : Icons.visibility_off_outlined,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              suffixIconConstraints: (widget.isDense != null)
                  ? const BoxConstraints(maxHeight: 33)
                  : null,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}

class CustomInputFieldPassword extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? passwordCtr;
  final String? Function(String?) validator;
  final bool suffixIcon;
  final bool? isDense;
  final bool obscureText;

  const CustomInputFieldPassword(
      {Key? key,
      required this.labelText,
      required this.hintText,
      required this.passwordCtr,
      required this.validator,
      this.suffixIcon = false,
      this.isDense,
      this.obscureText = false})
      : super(key: key);

  @override
  State<CustomInputFieldPassword> createState() =>
      _CustomInputFieldPasswordState();
}

class _CustomInputFieldPasswordState extends State<CustomInputFieldPassword> {
  //
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.labelText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            obscureText: (widget.obscureText && _obscureText),
            controller: widget.passwordCtr,
            decoration: InputDecoration(
              isDense: (widget.isDense != null) ? widget.isDense : false,
              hintText: widget.hintText,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryColor)),
              suffixIcon: widget.suffixIcon
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.remove_red_eye
                            : Icons.visibility_off_outlined,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              suffixIconConstraints: (widget.isDense != null)
                  ? const BoxConstraints(maxHeight: 33)
                  : null,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}

class CustomInputNameField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? nameCtrl;
  final String? Function(String?) validator;
  final bool suffixIcon;
  final bool? isDense;
  final bool obscureText;

  const CustomInputNameField(
      {Key? key,
      required this.labelText,
      required this.hintText,
      required this.nameCtrl,
      required this.validator,
      this.suffixIcon = false,
      this.isDense,
      this.obscureText = false})
      : super(key: key);

  @override
  State<CustomInputNameField> createState() => _CustomInputNameFieldState();
}

class _CustomInputNameFieldState extends State<CustomInputNameField> {
  //
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.labelText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            obscureText: (widget.obscureText && _obscureText),
            controller: widget.nameCtrl,
            decoration: InputDecoration(
              isDense: (widget.isDense != null) ? widget.isDense : false,
              hintText: widget.hintText,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryColor)),
              suffixIcon: widget.suffixIcon
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.remove_red_eye
                            : Icons.visibility_off_outlined,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              suffixIconConstraints: (widget.isDense != null)
                  ? const BoxConstraints(maxHeight: 33)
                  : null,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}

class CustomFormButton extends StatelessWidget {
  final String innerText;
  final void Function()? onPressed;
  const CustomFormButton(
      {Key? key, required this.innerText, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final enabled = onPressed != null;
    return Container(
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: enabled ? Colors.black : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(26),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          innerText,
          style: TextStyle(
            color: enabled ? Colors.white : Colors.white70,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class CustomFormButtonOutline extends StatelessWidget {
  final String innerText;
  final void Function()? onPressed;
  const CustomFormButtonOutline(
      {Key? key, required this.innerText, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(left: 10, right: 10),
      width: mediaWidth(context),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              width: 1.0, color: const Color.fromARGB(255, 142, 36, 28))),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          innerText,
          style: const TextStyle(
              color: Color.fromARGB(255, 142, 36, 28), fontSize: 14),
        ),
      ),
    );
  }
}

class CustomFormButtonOther extends StatelessWidget {
  final String innerText;
  final void Function()? onPressed;
  const CustomFormButtonOther(
      {Key? key, required this.innerText, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(left: 10, right: 10),
      width: mediaWidth(context),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          innerText,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
