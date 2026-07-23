import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Pages/client/reservation_form_page.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/Utils/size.dart';
import 'package:E_louma/widget/shimmersAnimation.dart';
import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProductDetailCustomerPages extends StatefulWidget {
  final ProductInterface product;
  final List<ProductInterface> listProduct;

  const ProductDetailCustomerPages(
      {super.key, required this.product, required this.listProduct});

  @override
  State<ProductDetailCustomerPages> createState() =>
      _ProductDetailCustomerPagesState();
}

class _ProductDetailCustomerPagesState
    extends State<ProductDetailCustomerPages> {
  final PageController _pageController = PageController();

  String getCondition(String condition) {
    switch (condition) {
      case "neuf":
        return "Neuf";
      case "seconde_main":
        return "Second main";
      case "tres_bon_etat":
        return "Trés bon état";
      case "bon_etat":
        return "Bon état";
      case "satisfaisant":
        return "Satisfaisant";

      default:
    }
    return "";
  }

  bool showShimmers = false;
  List<ProductInterface> _filteredOtherProduct = [];
  List<ProductInterface> filterOtherProduct(String idProduct) {
    _filteredOtherProduct =
        widget.listProduct.where((product) => product.id != idProduct).toList();
    return _filteredOtherProduct;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.08),
            )
          ],
        ),
        child: Row(
          children: [
            // Container(
            //   width: 60,
            //   height: 60,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20),
            //     border: Border.all(color: Colors.black12),
            //   ),
            //   child: const Icon(Icons.favorite_border),
            // ),
            // const SizedBox(width: 16),
            Expanded(
                child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ReservationFormPage(product: widget.product),
                  ),
                );
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff111111),
                      Color(0xff2B2B2B),
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Acheter maintenant",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          /// APP BAR
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: primaryColor,
            leading: _circleButton(Icons.arrow_back),
            actions: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 16),
              //   child: _circleButton(Icons.shopping_bag_outlined),
              // )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  /// IMAGES
                  // PageView.builder(
                  //   controller: _pageController,
                  //   itemCount: widget.product.image.length,
                  //   onPageChanged: (value) {},
                  //   itemBuilder: (_, index) {
                  //     return Hero(
                  //       tag: widget.product.title,
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //           image: DecorationImage(
                  //             image: NetworkImage(widget.product.image[index]),
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 1.3,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                        ),
                        items: imageSliders(),
                      )),

                  /// GRADIENT
                  // Container(
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       begin: Alignment.bottomCenter,
                  //       end: Alignment.topCenter,
                  //       colors: [
                  //         Colors.white.withOpacity(.5),
                  //         Colors.transparent,
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  /// INDICATORS
                ],
              ),
            ),
          ),

          /// CONTENT
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// CATEGORY
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 14,
                  //     vertical: 8,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.black,
                  //     borderRadius: BorderRadius.circular(30),
                  //   ),
                  //   child: const Text(
                  //     "Premium Shoes",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 20),

                  /// TITLE

                  Text(
                    widget.product.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// PRICE + RATING
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.product.price} FCFA",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Container(
                      //     width: 120,
                      //     height: 30,
                      //     // margin: EdgeInsets.all(20),
                      //     decoration: BoxDecoration(
                      //       color: Colors.orange.shade50,
                      //       borderRadius: BorderRadius.circular(20),
                      //     ),
                      //     child: Center(
                      //         child: Text(
                      //       getCondition(widget.product.condition),
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     )))
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: mediaWidth(context) / 2.5,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                            getCondition(widget.product.condition),
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                      Container(
                          width: mediaWidth(context) / 2.5,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                            widget.product.pricenegotiable
                                ? "Prix négociable"
                                : "Prix non négociable",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                    ],
                  ),
                  const SizedBox(height: 30),

                  /// COLORS

                  const SizedBox(height: 30),

                  /// DESCRIPTION
                  Text(
                    widget.product.brand,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Text(
                  //   "Experience premium comfort and futuristic style with the Nike Air Max Pulse. Designed with breathable materials and ultra responsive cushioning.",
                  //   style: TextStyle(
                  //     color: Colors.grey.shade700,
                  //     fontSize: 16,
                  //     height: 1.7,
                  //   ),
                  // ),

                  // const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: (filterOtherProduct(widget.product.id).length > 0)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Container(
                              margin: EdgeInsets.all(20),
                              child: Text("Autres produits",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ))),
                          SizedBox(
                            height: 180,
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  filterOtherProduct(widget.product.id).length,
                              itemBuilder: (context, index) {
                                if (showShimmers) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: SizedBox(
                                      width: 150,
                                      child: ShimmersPage().statShimmer(),
                                    ),
                                  );
                                }

                                final element = filterOtherProduct(
                                    widget.product.id)[index];

                                return Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: SizedBox(
                                      width: 150,
                                      child: makeProductDetailsUser(
                                        detailProduct: element,
                                      )),
                                );
                              },
                            ),
                          ),
                        ])
                  : Container()),

          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),

          // Container(
          //   height: 150,
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     children: <Widget>[
          //       for (var element in widget.listProduct)
          //         showShimmers
          //             ? ShimmersPage().statShimmer()
          //             : makeProductDetailsUser(detailProduct: element),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget makeProductDetailsUser({required ProductInterface detailProduct}) {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetailCustomerPages(
                              product: detailProduct,
                              listProduct: widget.listProduct,
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
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FadeInUp(
                            duration: Duration(milliseconds: 1400),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 100,
                                height: 30,
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.black.withOpacity(.8),
                                ),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      detailProduct.category.name,
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
                            )),
                        (detailProduct.status == "vendu")
                            ? FadeInUp(
                                duration: Duration(milliseconds: 1400),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green.withOpacity(.8),
                                    ),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          detailProduct.status,
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
                            : Container(),
                      ]),
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
                    ],
                  ),
                ],
              ),
            )));
  }

  List<Widget> imageSliders() {
    final List<Widget> dataList = [];
    for (var element in widget.product.image) {
      dataList.add(Container(
          height: 200,
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: NetworkImage(element), fit: BoxFit.cover))));
    }
    return widget.product.image
        .map((item) => Container(
                child: GestureDetector(
              onTap: () {
                showMaterialModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  context: context,
                  builder: (context) => SingleChildScrollView(
                    controller: ModalScrollController.of(context),
                    child: Container(
                        height: mediaHeight(context) / 1,
                        color: Colors.black,
                        child: ImageShowView(imgList: dataList)),
                  ),
                );
              },
              child: Container(
                height: mediaHeight(context) / 2,
                width: mediaWidth(context),
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                          item,
                          fit: BoxFit.cover,
                          height: mediaHeight(context) / 2,
                          width: mediaWidth(context),
                        ),
                      ],
                    )),
              ),
            )))
        .toList();
  }

  Widget colorItem(Color color, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? Colors.black : Colors.transparent,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: color,
      ),
    );
  }

  Widget reviewCard(Map<String, dynamic> clients) {
    return GestureDetector(
        onTap: () {
          // showclientsDetails(context, clients);
        },
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: primaryColor,
                  child: Text(
                    clients["name"][0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clients["name"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        clients["phone"],
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
        ]));
  }

  Widget _circleButton(IconData icon) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.9),
            shape: BoxShape.circle,
          ),
          child: Icon(icon),
        ));
  }
}

class ImageShowView extends StatefulWidget {
  final List<Widget> imgList;

  const ImageShowView({Key? key, required this.imgList}) : super(key: key);

  @override
  _ImageShowViewState createState() => _ImageShowViewState();
}

class _ImageShowViewState extends State<ImageShowView> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
          margin: EdgeInsets.only(top: 130, right: 10),
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => {Navigator.of(context).pop()},
            icon: Icon(Icons.close),
            color: primaryColor,
          )), // in
      Container(
          margin: EdgeInsets.only(top: 100, bottom: 100),
          height: mediaHeight(context) / 2,
          child: ImageSlideshow(
              indicatorColor: primaryColor,
              onPageChanged: (value) {
                debugPrint('Page changed: $value');
              },
              //autoPlayInterval: 3000,
              isLoop: true,
              children: widget.imgList
              //  [
              //   Image.asset(
              //     'images/sample_image_1.jpg',
              //     fit: BoxFit.cover,
              //   ),
              //   Image.asset(
              //     'images/sample_image_2.jpg',
              //     fit: BoxFit.cover,
              //   ),
              //   Image.asset(
              //     'images/sample_image_3.jpg',
              //     fit: BoxFit.cover,
              //   ),
              // ],
              ))
    ]);
  }
}
