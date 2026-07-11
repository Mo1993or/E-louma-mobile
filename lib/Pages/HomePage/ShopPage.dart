import 'package:E_louma/Pages/Component/makeCategory.dart';
import 'package:E_louma/constant.dart';
import 'package:animate_do/animate_do.dart';
import 'package:E_louma/Pages/HomePage/SearchProduct.dart';
import 'package:E_louma/Pages/dashboardPage.dart';
import 'package:E_louma/Pages/Auth/signIn.dart';
import 'package:E_louma/size.dart';
import 'package:E_louma/widget/add_product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  bool savedConnexion = false;
  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'savedConnexion';
    bool value = prefs.getBool(key) ?? false;
    setState(() {
      savedConnexion = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            width: mediaWidth(context) / 2,
            decoration: BoxDecoration(
              color: Color.fromARGB(209, 0, 0, 0),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchProductPage()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        height: 55,
                        width: 40,
                        child: Center(
                            child: Icon(
                          Icons.search,
                          color: primaryColor,
                        )),
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddProductPage()));
                        // showMaterialModalBottomSheet(
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.only(
                        //         topLeft: Radius.circular(20),
                        //         topRight: Radius.circular(20)),
                        //   ),
                        //   context: context,
                        //   builder: (context) => StatefulBuilder(
                        //     builder: (BuildContext context, setState) =>
                        //         SingleChildScrollView(
                        //       controller: ModalScrollController.of(context),
                        //       child: Container(
                        //           height: mediaHeight(context) / 3,
                        //           color: null,
                        //           child: Column(
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             children: [
                        //               Container(
                        //                 margin:
                        //                     EdgeInsets.only(top: 8, bottom: 20),
                        //                 width: 90,
                        //                 height: 6,
                        //                 decoration: BoxDecoration(
                        //                     borderRadius:
                        //                         BorderRadius.circular(25),
                        //                     color: Color.fromARGB(
                        //                         255, 183, 199, 228)),
                        //               ),
                        //               SizedBox(height: 20),
                        //               // panelDevice(),
                        //               // SizedBox(height: 20),
                        //               // darkMode()
                        //             ],
                        //           )),
                        //     ),
                        //   ),
                        // );
                      },
                      child: Container(
                        // margin: EdgeInsets.only(left: 20),
                        height: 55,
                        width: 40,
                        child: Center(
                            child: Icon(
                          Icons.add,
                          color: primaryColor,
                        )),
                      )),
                  GestureDetector(
                      onTap: () {
                        savedConnexion
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashboardPage()))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        height: 55,
                        width: 40,
                        child: Center(
                            child: Icon(
                          Icons.person,
                          color: primaryColor,
                        )),
                      )),
                ]))
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FadeInUp(
                duration: Duration(milliseconds: 1000),
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.jpg'),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                          Colors.black.withOpacity(.8),
                          Colors.black.withOpacity(.2),
                        ])),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FadeInUp(
                                  duration: Duration(milliseconds: 1200),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                  )),
                              FadeInUp(
                                  duration: Duration(milliseconds: 1300),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FadeInUp(
                                    duration: Duration(milliseconds: 1500),
                                    child: Text(
                                      "Nos produits",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                FadeInUp(
                                    duration: Duration(milliseconds: 1700),
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SearchProductPage()));
                                            },
                                            child: Text(
                                              "VOIR PLUS",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 15,
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            FadeInUp(
                duration: Duration(milliseconds: 1400),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Mes articles",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("Tout")
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            makeBestCategory(
                                image: 'assets/images/tech.jpg',
                                title: 'Tech',
                                tag: "Tech",
                                context: context),
                            makeBestCategory(
                                image: 'assets/images/watch.jpg',
                                title: 'Montre',
                                tag: "Watch",
                                context: context),
                            makeBestCategory(
                                image: 'assets/images/perfume.jpg',
                                title: 'Parfum',
                                tag: "Perfum",
                                context: context),
                            makeBestCategory(
                                image: 'assets/images/glass.jpg',
                                title: 'Lunettes',
                                tag: "Glass",
                                context: context),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Categories",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("Tout")
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            makeCategory(
                                image: 'assets/images/beauty.jpg',
                                title: 'Beauté',
                                tag: 'beauty',
                                context: context),
                            makeCategory(
                                image: 'assets/images/clothes.jpg',
                                title: 'Vêtements',
                                tag: 'clothes',
                                context: context),
                            makeCategory(
                                image: 'assets/images/perfume.jpg',
                                title: 'Parfum',
                                tag: 'perfume',
                                context: context),
                            makeCategory(
                                image: 'assets/images/glass.jpg',
                                title: 'Lunettes',
                                tag: 'glass',
                                context: context),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
