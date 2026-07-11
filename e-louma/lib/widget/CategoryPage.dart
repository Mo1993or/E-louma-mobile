import 'package:E_louma/Interface/categoryInterface.dart';
import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Utils/size.dart';
import 'package:E_louma/services/product_service.dart';
import 'package:E_louma/widget/product_details_page.dart';
import 'package:E_louma/widget/product_details_seller.dart';
import 'package:animate_do/animate_do.dart';
import 'package:E_louma/data/catalog_data.dart';
import 'package:E_louma/widget/product_details.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategoryPage extends StatefulWidget {
  final String? title;
  final String? image;
  final String? tag;
  final List<ProductInterface> listProduct;
  final bool isComming;

  const CategoryPage(
      {Key? key,
      this.title,
      this.image,
      this.tag,
      required this.listProduct,
      required this.isComming})
      : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  var checkStatus = "";
  _fetchProducts() async {
    try {
      await ProductService().fetchProducts().then((value) {
        setState(() {
          print("values $value");
        });
      });
    } catch (e) {
      print("error $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Hero(
              tag: widget.tag!,
              child: Material(
                child: Container(
                  height: 360,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.image!),
                          fit: BoxFit.cover)),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                          Colors.black.withOpacity(.8),
                          Colors.black.withOpacity(.1),
                        ])),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: <Widget>[
                            //     FadeInUp(
                            //         duration: Duration(milliseconds: 1200),
                            //         child: IconButton(
                            //           icon: Icon(
                            //             Icons.search,
                            //             color: Colors.white,
                            //           ),
                            //           onPressed: () {},
                            //         )),
                            //     FadeInUp(
                            //         duration: Duration(milliseconds: 1200),
                            //         child: IconButton(
                            //           icon: Icon(
                            //             Icons.favorite,
                            //             color: Colors.white,
                            //           ),
                            //           onPressed: () {},
                            //         )),
                            //     FadeInUp(
                            //         duration: Duration(milliseconds: 1300),
                            //         child: IconButton(
                            //           icon: Icon(
                            //             Icons.shopping_cart,
                            //             color: Colors.white,
                            //           ),
                            //           onPressed: () {},
                            //         )),
                            //   ],
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        FadeInUp(
                            duration: Duration(milliseconds: 1200),
                            child: Text(
                              widget.title!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                      duration: Duration(milliseconds: 1400),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Les produits",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          // Row(
                          //   children: <Widget>[
                          //     Text(
                          //       "Voir Plus",
                          //       style: TextStyle(color: Colors.grey),
                          //     ),
                          //     SizedBox(
                          //       width: 5,
                          //     ),
                          //     Icon(
                          //       Icons.arrow_forward_ios,
                          //       size: 11,
                          //       color: Colors.grey,
                          //     )
                          //   ],
                          // ),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),

                  StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: [
                        for (int i = 0; i < widget.listProduct.length; i++)
                          if (widget.title ==
                              widget.listProduct[i].category.name)
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2,
                              child: FadeInUp(
                                duration: Duration(milliseconds: 1500 + i * 60),
                                child: makeProduct(
                                    detailProduct: widget.listProduct[i]),
                              ),
                            )
                        // else
                        //   Padding(
                        //     padding: const EdgeInsets.symmetric(vertical: 32),
                        //     child: Center(
                        //       child: Text(
                        //         '${widget.title} ${widget.listProduct[0].category.name} Aucun produit dans cette catégorie.',
                        //         style: TextStyle(color: Colors.grey.shade600),
                        //       ),
                        //     ),
                        //   )
                      ])

                  // GridView.count(
                  //   scrollDirection: Axis.vertical,
                  //   crossAxisCount: 2,
                  //   children: [
                  // Container(
                  //   color: Colors.red,
                  //   // child:
                  //   // FadeInUp(
                  //   //     duration: Duration(milliseconds: 1500),
                  //   //     child: makeProduct(
                  //   //         image: 'assets/images/beauty-1.jpg',
                  //   //         title: 'Beauté',
                  //   //         price: '100\$')
                  //   //         )
                  // ),
                  // Container(
                  //   color: Colors.amber,
                  //   // child: FadeInUp(
                  //   //     duration: Duration(milliseconds: 1600),
                  //   //     child: makeProduct(
                  //   //         image: 'assets/images/clothes-1.jpg',
                  //   //         title: 'Vêtements',
                  //   //         price: '100\$'))
                  // ),
                  // FadeInUp(
                  //     duration: Duration(milliseconds: 1700),
                  //     child: makeProduct(
                  //         image: 'assets/images/glass.jpg',
                  //         title: 'Lunettes',
                  //         price: '100\$')),
                  // FadeInUp(
                  //     duration: Duration(milliseconds: 1800),
                  //     child: makeProduct(
                  //         image: 'assets/images/perfume.jpg',
                  //         title: 'Parfum',
                  //         price: '100\$')),
                  // FadeInUp(
                  //     duration: Duration(milliseconds: 1900),
                  //     child: makeProduct(
                  //         image: 'assets/images/person.jpg',
                  //         title: 'Persone',
                  //         price: '100\$')
                  // ),
                  //   ],
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget makeProduct({required ProductInterface detailProduct}) {
    return Container(
        height: 200,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: NetworkImage(detailProduct.image[0]),
                fit: BoxFit.cover)),
        child: GestureDetector(
            onTap: () {
              if (detailProduct.status == "vendu") {
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Information',
                    message: 'Produit déjà vendu',
                    contentType: ContentType.help,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              } else {
                (widget.isComming)
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetailPages(
                                  product: detailProduct,
                                )))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetailCustomerPages(
                                  product: detailProduct,
                                )));
              }
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient:
                      LinearGradient(begin: Alignment.bottomRight, colors: [
                    Colors.black.withOpacity(.8),
                    Colors.black.withOpacity(.1),
                  ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  (widget.isComming)
                      ? FadeInUp(
                          duration: Duration(milliseconds: 1400),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 100,
                              height: 30,
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.green.withOpacity(.8),
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    (detailProduct.status == "vendu")
                                        ? "Vendu"
                                        : "${detailProduct.reservations} clients",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14),
                                  )),
                            ),
                            // Icon(
                            //         Icons.favorite_border,
                            //         color: Colors.white,
                            //       ),
                          ))
                      : FadeInUp(
                          duration: Duration(milliseconds: 1400),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: (detailProduct.status == "vendu")
                                ? Container(
                                    width: 100,
                                    height: 30,
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green.withOpacity(.8),
                                    ),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          (detailProduct.status == "vendu")
                                              ? "Vendu"
                                              : "${detailProduct.reservations} clients",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                        )),
                                  )
                                : Container(),
                            // Icon(
                            //         Icons.favorite_border,
                            //         color: Colors.white,
                            //       ),
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
                              child: Container(
                                  width: 100,
                                  child: Text(
                                    detailProduct.title,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ))),
                          FadeInUp(
                              duration: Duration(milliseconds: 1500),
                              child: Text(
                                "${detailProduct.price} FCFA",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
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
            )));
  }
}
