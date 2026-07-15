import 'package:E_louma/Interface/categoryInterface.dart';
import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Pages/HomePage/ShopPage.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/Utils/size.dart';
import 'package:E_louma/services/product_service.dart';
import 'package:E_louma/services/reservation_service.dart';
import 'package:E_louma/widget/product_details_page.dart';
import 'package:E_louma/widget/showAlertCustom.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailPages extends StatefulWidget {
  final ProductInterface product;

  const ProductDetailPages({super.key, required this.product});

  @override
  State<ProductDetailPages> createState() => _ProductDetailPagesState();
}

class _ProductDetailPagesState extends State<ProductDetailPages> {
  final PageController _pageController = PageController();
  List<ReservationInterface> listReservationFilter = [];
  List<String> listNameCat = [];
  bool showShimmers = true;
  bool checkSeller = false;

  _fetchReservation() async {
    print("values access ${widget.product.id}");
    try {
      await ProductService().fetchReservation(widget.product.id).then((value) {
        setState(() {
          print("values $value");
          listReservationFilter = value;

          showShimmers = false;
        });
      });
    } catch (e) {}
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

  _launchWhatsapp(String produit, String tel) async {
    var url =
        "https://wa.me/$tel?text= Bonjour vous avez commandez le produit ${produit} sur E-LOUMA?";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  int currentImage = 0;

  void showclientsDetails(
    BuildContext context,
    ProductInterface product,
    ReservationInterface clients,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HANDLE
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 24),

              CircleAvatar(
                radius: 38,
                backgroundColor: primaryColor,
                child: Text(
                  clients.fullname[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                clients.fullname,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              buildInfoTile(
                Icons.phone_outlined,
                "Téléphone",
                clients.phonenumber,
              ),

              const SizedBox(height: 16),

              // buildInfoTile(
              //   Icons.location_on_outlined,
              //   "Adresse",
              //   clients["address"],
              // ),

              const SizedBox(height: 16),

              buildInfoTile(
                Icons.email_outlined,
                "Email",
                clients.email,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await _makePhoneCall("+221${clients.phonenumber}");
                    // Navigator.pop(context);

                    /// ACTION COMMANDE
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Appeler 📞",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await _launchWhatsapp(product.title, clients.phonenumber);
                    Navigator.pop(context);

                    /// ACTION COMMANDE
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Discuter sur WhatsApp ✆",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget buildInfoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildclientsItem(
    BuildContext context,
    ProductInterface product,
    ReservationInterface clients,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => showclientsDetails(context, product, clients),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            /// AVATAR
            CircleAvatar(
              radius: 28,
              backgroundColor: primaryColor,
              child: Text(
                clients.fullname[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 16),

            /// INFOS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clients.fullname,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    clients.phonenumber,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchReservation();
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
              onTap: () async {
                try {
                  if (checkSeller || widget.product.status == "vendu") {
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Déjà vendu',
                        message: 'Commande déjà vendu',
                        contentType: ContentType.warning,
                      ),
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  } else {
                    showAlertDialog(context);
                    var data = {
                      "product": widget.product.id,
                    };
                    var result =
                        await ProductService().validateRservation(data);

                    print("result $result");
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ShopPage()));
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Succès',
                        message: 'Commande marquée comme vendu',
                        contentType: ContentType.success,
                      ),
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                    setState(() {
                      checkSeller = true;
                    });
                  }
                } catch (err) {
                  print("err $err");
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Erreur',
                      message: 'Une erreur s\'est produite',
                      contentType: ContentType.failure,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                }
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    colors: [
                      (checkSeller || widget.product.status == "vendu")
                          ? Colors.green
                          : Color(0xff111111),
                      (checkSeller || widget.product.status == "vendu")
                          ? Colors.green
                          : Color(0xff2B2B2B),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    (checkSeller || widget.product.status == "vendu")
                        ? "Vendu"
                        : "Marquer comme déjà vendu",
                    style: const TextStyle(
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
              padding: const EdgeInsets.all(24),
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
                  ///
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.info,
                                showConfirmBtn: true,
                                showCancelBtn: true,
                                confirmBtnText: 'Oui',
                                cancelBtnText: "Non",
                                confirmBtnColor: primaryColor,
                                title: "Suppression",
                                text:
                                    'Êtes vous sûre de vouloir supprimer ce produit ?',
                                onConfirmBtnTap: () async {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => ShopPage()),
                                    (_) => false,
                                  );
                                },
                              );
                            },
                            child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.orange.shade50,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.orange.shade50,
                                  child: Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.red.shade900,
                                  ),
                                ))),
                      ]),
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
                      Container(
                          width: 120,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                              child: Text(
                            widget.product.condition,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )))
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

                  const SizedBox(height: 30),

                  /// REVIEWS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Clients",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      // Text(
                      //   "See all",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // )
                    ],
                  ),

                  const SizedBox(height: 20),
                  for (var item in listReservationFilter)
                    reviewCard(widget.product, item),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget reviewCard(ProductInterface produit, ReservationInterface clients) {
    return GestureDetector(
        onTap: () {
          showclientsDetails(context, produit, clients);
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
                    clients.fullname[0],
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
                        clients.fullname,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        clients.phonenumber,
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
