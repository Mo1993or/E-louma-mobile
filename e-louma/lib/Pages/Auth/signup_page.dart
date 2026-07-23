import 'dart:io';
import 'package:E_louma/Pages/Auth/Verify_otp.dart';
import 'package:E_louma/Pages/Auth/signIn.dart';
import 'package:E_louma/Utils/api_error.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/models/user_role.dart';
import 'package:E_louma/services/auth_service.dart';
import 'package:E_louma/services/session_service.dart';
import 'package:E_louma/Utils/size.dart';
import 'package:E_louma/widget/showAlertCustom.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? _profileImage;
  UserRole _accountRole = UserRole.client;
  bool accepted = false;
  final _signupFormKey = GlobalKey<FormState>();

  Future _pickProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => _profileImage = imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image error: $e');
    }
  }

  _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'email';
    var value = prefs.setString(key, email);
    debugPrint("value $value");
  }

  _launchCondition(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  TextEditingController nameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();
  var phoneNumberController = TextEditingController();
  String indicator = "";
  String initialCountry = 'SN';
  PhoneNumber phoneText = PhoneNumber(isoCode: 'SN');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _signupFormKey,
          child: Stack(
            children: [
              const PageHeader(),
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const PageHeading(
                      title: 'Inscription',
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 18),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const Text(
                    //         'Type de compte',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 16),
                    //       ),
                    //       const SizedBox(height: 8),
                    //       Wrap(
                    //         spacing: 10,
                    //         children: [
                    //           ChoiceChip(
                    //             label: const Text('Client'),
                    //             selected: _accountRole == UserRole.client,
                    //             onSelected: (_) => setState(
                    //                 () => _accountRole = UserRole.client),
                    //           ),
                    //           ChoiceChip(
                    //             label: const Text('Vendeur'),
                    //             selected: _accountRole == UserRole.seller,
                    //             onSelected: (_) => setState(
                    //                 () => _accountRole = UserRole.seller),
                    //           ),
                    //         ],
                    //       ),
                    //       Text(
                    //         _accountRole == UserRole.client
                    //             ? 'Parcourez les articles et réservez ceux qui vous plaisent.'
                    //             : 'Ajoutez des articles et consultez vos stats.',
                    //         style: TextStyle(
                    //           fontSize: 12,
                    //           color: Colors.grey.shade700,
                    //           height: 1.3,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 130,
                    //   height: 130,
                    //   child: CircleAvatar(
                    //     backgroundColor: Colors.grey.shade200,
                    //     backgroundImage: _profileImage != null
                    //         ? FileImage(_profileImage!)
                    //         : null,
                    //     child: Stack(
                    //       children: [
                    //         Positioned(
                    //           bottom: 5,
                    //           right: 5,
                    //           child: GestureDetector(
                    //             onTap: _pickProfileImage,
                    //             child: Container(
                    //               height: 50,
                    //               width: 50,
                    //               decoration: BoxDecoration(
                    //                 color: primaryColor,
                    //                 border: Border.all(
                    //                     color: Colors.white, width: 3),
                    //                 borderRadius: BorderRadius.circular(25),
                    //               ),
                    //               child: const Icon(
                    //                 Icons.camera_alt_sharp,
                    //                 color: Colors.white,
                    //                 size: 25,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomInputNameField(
                      labelText: 'Nom et prenom',
                      hintText: 'Votre nom et prenom',
                      isDense: true,
                      validator: (textValue) {
                        if (textValue == null || textValue.isEmpty) {
                          return 'Nom obligatoire!';
                        }
                        return null;
                      },
                      nameCtrl: nameCtr,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomInputField(
                      labelText: 'Email',
                      hintText: 'Votre email',
                      isDense: true,
                      validator: (textValue) {
                        if (textValue == null || textValue.isEmpty) {
                          return 'Email obligatoire!';
                        }
                        // if(!EmailValidator.validate(textValue)) {
                        //   return 'Please enter a valid email';
                        // }
                        return null;
                      },
                      emailCtr: emailCtr,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 30, right: 30),
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            indicator = number.toString();
                          },
                          onInputValidated: (bool value) {},
                          selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            setSelectorButtonAsPrefixIcon: true,
                            leadingPadding: 14,
                            useEmoji: true,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: TextStyle(color: primaryColor),
                          initialValue: phoneText,
                          textFieldController: phoneNumberController,
                          formatInput: false,
                          inputDecoration: InputDecoration(
                              hintText: "Numéro de téléphone (WhatsApp)",
                              labelStyle: TextStyle(color: primaryColor),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor))),
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          onSaved: (PhoneNumber number) {},
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomInputFieldPassword(
                      labelText: 'Mot de passe',
                      hintText: 'Ton mot de passe',
                      isDense: true,
                      obscureText: true,
                      validator: (textValue) {
                        if (textValue == null || textValue.isEmpty) {
                          return 'Mot de passe obligatoire!';
                        }
                        if (textValue.length < 8) {
                          return 'Il faut au moins 8 caractères';
                        }
                        return null;
                      },
                      suffixIcon: true,
                      passwordCtr: passwordCtr,
                    ),
                    const SizedBox(height: 25),

                    Container(
                        margin: EdgeInsets.only(left: 30, right: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              activeColor: primaryColor,
                              value: accepted,
                              onChanged: (value) {
                                setState(() {
                                  accepted = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Wrap(
                                  children: [
                                    const Text(
                                      "J'accepte les ",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await _launchCondition(
                                            "https://e-louma.netlify.app/cgu-politique-confidentialite");
                                        // Ouvrir les CGU
                                      },
                                      child: const Text(
                                        "Conditions d'utilisation",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          // decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    const Text(" et la "),
                                    GestureDetector(
                                      onTap: () async {
                                        await _launchCondition(
                                            "https://e-louma.org/cgu-politique-confidentialite");
                                        // Ouvrir la politique
                                      },
                                      child: const Text(
                                        "Politique de confidentialité",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          // decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    const Text("."),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 22,
                    ),
                    CustomFormButton(
                      innerText: 'S\'inscrire',
                      onPressed: _handleSignupUser,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Ton compte existe déjà ? ',
                            style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff939393),
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()))
                            },
                            child: const Text(
                              'Se connecter',
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
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignupUser() async {
    if (_signupFormKey.currentState!.validate() && accepted) {
      try {
        showAlertDialog(context);

        var data = {
          "fullname": nameCtr.text,
          "email": emailCtr.text,
          "phonenumber": phoneNumberController.text,
          "password": passwordCtr.text
        };
        var result = await AuthService().signUp(data);

        print("result $result");
        if (!mounted) return;
        Navigator.pop(context);

        await _saveEmail(emailCtr.text);
        if (!mounted) return;

        final successMessage = extractApiErrorMessage(
          result is Map ? result['message'] : null,
          fallback: 'Inscription réussie',
        );

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Succès',
            message: successMessage,
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (error) {
        print("error $error");
        if (mounted) {
          Navigator.pop(context);
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Inscription échouée',
              message: cleanExceptionMessage(
                error,
                fallback: 'Inscription échouée',
              ),
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      }
    } else {
      if (!accepted) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Information',
            message:
                'Cochez pour accépter les conditions d\'utilisation et la politique de confidentialité',
            contentType: ContentType.help,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }
  }
}
