import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:animate_do/animate_do.dart';
import 'package:E_louma/widget/CategoryPage.dart';
import 'package:E_louma/Pages/Settings/dashboardPage.dart';
import 'package:E_louma/Pages/Auth/signIn.dart';
import 'package:E_louma/Utils/size.dart';
import 'package:E_louma/widget/add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_search/voice_search.dart';

class SearchProductPage extends StatefulWidget {
  @override
  _SearchProductPageState createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
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
                      onTap: () {},
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => AddProductPage()));
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
                    height: mediaHeight(context) / 3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/background.jpg'),
                            fit: BoxFit.cover)),
                    child: Stack(children: [
                      Container(
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
                                  // FadeInUp(
                                  //     duration: Duration(milliseconds: 1200),
                                  //     child: IconButton(
                                  //       icon: Icon(
                                  //         Icons.favorite,
                                  //         color: Colors.white,
                                  //       ),
                                  //       onPressed: () {},
                                  //     )),
                                  // FadeInUp(
                                  //     duration: Duration(milliseconds: 1300),
                                  //     child: IconButton(
                                  //       icon: Icon(
                                  //         Icons.shopping_cart,
                                  //         color: Colors.white,
                                  //       ),
                                  //       onPressed: () {},
                                  //     )),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                      FadeInUp(
                          duration: Duration(milliseconds: 1400),
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 100, right: 20, top: 60),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                            child: TextField(
                              cursorColor: primaryColor,
                              style: TextStyle(color: primaryColor),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: primaryColor,
                                ),
                                labelStyle: TextStyle(
                                  color: primaryColor,
                                ),
                                hintText: "Rechercher...",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          )),
                    ]))),
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
                            "Tout nos produit",
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
                      StaggeredGrid.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          children: [
                            StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 2,
                                child: FadeInUp(
                                    duration: Duration(milliseconds: 1600),
                                    child: makeProduct(
                                        image: 'assets/images/clothes-1.jpg',
                                        title: 'Vêtements',
                                        price: '10 000 FCFA'))),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2,
                              child: FadeInUp(
                                  duration: Duration(milliseconds: 1500),
                                  child: makeProduct(
                                      image: 'assets/images/beauty-1.jpg',
                                      title: 'Beauté',
                                      price: '10 000 FCFA')),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2,
                              child: FadeInUp(
                                  duration: Duration(milliseconds: 1800),
                                  child: makeProduct(
                                      image: 'assets/images/perfume.jpg',
                                      title: 'Parfum',
                                      price: '10 000 FCFA')),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2,
                              child: FadeInUp(
                                  duration: Duration(milliseconds: 1800),
                                  child: makeProduct(
                                      image: 'assets/images/glass.jpg',
                                      title: 'Parfum',
                                      price: '10 000 FCFA')),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2,
                              child: FadeInUp(
                                  duration: Duration(milliseconds: 1900),
                                  child: makeProduct(
                                      image: 'assets/images/person.jpg',
                                      title: 'Persone',
                                      price: '10 000 FCFA')),
                            ),
                          ]),
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

  Widget makeCategory({image, title, tag}) {
    return AspectRatio(
      aspectRatio: 2 / 2.2,
      child: Hero(
        tag: tag,
        child: GestureDetector(
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => CategoryPage(
            //               image: image,
            //               title: title,
            //               tag: tag,
            //             )));
          },
          child: Material(
            child: Container(
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.cover)),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient:
                        LinearGradient(begin: Alignment.bottomRight, colors: [
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.0),
                    ])),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeBestCategory({image, title, tag}) {
    return AspectRatio(
        aspectRatio: 3 / 2.2,
        child: Hero(
            tag: tag,
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => CategoryPage(
                //               image: image,
                //               title: title,
                //               tag: tag,
                //             )));
              },
              child: Container(
                margin: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: AssetImage(image), fit: BoxFit.cover)),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                        Colors.black.withOpacity(.8),
                        Colors.black.withOpacity(.0),
                      ])),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                ),
              ),
            )));
  }
}

Widget makeProduct({image, title, price}) {
  return Container(
      height: 200,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
              Colors.black.withOpacity(.8),
              Colors.black.withOpacity(.1),
            ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FadeInUp(
                duration: Duration(milliseconds: 1400),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                        duration: Duration(milliseconds: 1500),
                        child: Text(
                          title,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                    FadeInUp(
                        duration: Duration(milliseconds: 1500),
                        child: Text(
                          price,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                // FadeInUp(
                //     duration: Duration(milliseconds: 2000),
                //     child: Container(
                //         width: 40,
                //         height: 40,
                //         margin: EdgeInsets.only(bottom: 10),
                //         decoration: BoxDecoration(
                //             shape: BoxShape.circle, color: Colors.white),
                //         child: Center(
                //           child: Icon(
                //             Icons.add_shopping_cart,
                //             size: 18,
                //             color: Colors.grey[700],
                //           ),
                //         )))
              ],
            ),
          ],
        ),
      ));
}
