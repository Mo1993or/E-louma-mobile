import 'package:E_louma/Interface/dashboardInterface.dart';
import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Pages/Auth/signIn.dart';
import 'package:E_louma/Pages/HomePage/Notification.dart';
import 'package:E_louma/Pages/client/client_discover_page.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/services/product_service.dart';
import 'package:E_louma/widget/showAlertCustom.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: add flutter_svg to pubspec.yaml

class ProfileScreen extends StatefulWidget {
  final SellerInterface? seller;
  const ProfileScreen({super.key, required this.seller});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: Container(),
        title: const Text("Profil",
            style: TextStyle(
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "${widget.seller?.fullname}",
              icon: Icon(Icons.person_outlined, color: Colors.blue),
              press: () => {},
            ),
            ProfileMenu(
              text: "Notifications",
              icon: Icon(Icons.notifications_outlined, color: Colors.blue),
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsPage()));
              },
            ),
            ProfileMenu(
              text: "Email\n${widget.seller?.email}",
              icon: Icon(Icons.email, color: Colors.blue),
              press: () {},
            ),
            // ProfileMenu(
            //   text: "Aide",
            //   icon: Icon(Icons.help_outline, color: Colors.blue),
            //   press: () {},
            // ),
            Container(
                margin: EdgeInsets.all(20),
                child: Column(children: [
                  CustomFormButtonOther(
                    innerText: 'Se deconnecter',
                    onPressed: () async {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.info,
                        showConfirmBtn: true,
                        showCancelBtn: true,
                        confirmBtnText: 'Oui',
                        cancelBtnText: "Non",
                        confirmBtnColor: Colors.red,
                        title: "Déconnexion",
                        text: 'Êtes vous sûre de vouloir vous déconnecter ?',
                        onConfirmBtnTap: () async {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => ClientDiscoverPage()),
                            (_) => false,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomFormButtonOutline(
                    innerText: 'Supprimer mon compte',
                    onPressed: () async {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.info,
                        showConfirmBtn: true,
                        showCancelBtn: true,
                        confirmBtnText: 'Oui',
                        cancelBtnText: "Non",
                        confirmBtnColor: Colors.red,
                        title: "Suppression compte",
                        text:
                            'Êtes vous sûre de vouloir supprimer ton compte ?',
                        onConfirmBtnTap: () async {
                          try {
                            Navigator.pop(context);
                            showAlertDialog(context);
                            await ProductService().deleteAccount();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => ClientDiscoverPage()),
                              (_) => false,
                            );
                          } catch (e) {
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/utilisateur.png"),
          ),
          // Positioned(
          //   right: -16,
          //   bottom: 0,
          //   child: SizedBox(
          //     height: 46,
          //     width: 46,
          //     child: TextButton(
          //       style: TextButton.styleFrom(
          //         foregroundColor: Colors.white,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(50),
          //           side: const BorderSide(color: Colors.white),
          //         ),
          //         backgroundColor: const Color(0xFFF5F6F9),
          //       ),
          //       onPressed: () {},
          //       child: SvgPicture.string(cameraIcon),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final Widget icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF757575),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }
}
