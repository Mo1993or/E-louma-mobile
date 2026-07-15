import 'package:E_louma/Interface/categoryInterface.dart';
import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Pages/Component/makeCategory.dart';
import 'package:E_louma/Pages/HomePage/Notification.dart';
import 'package:E_louma/Pages/Settings/dashboardPageTwo.dart';
import 'package:E_louma/Pages/client/reservations_list_page.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/services/product_service.dart';
import 'package:E_louma/widget/product_details.dart';
import 'package:E_louma/widget/product_details_page.dart';
import 'package:E_louma/widget/shimmersAnimation.dart';
import 'package:animate_do/animate_do.dart';
import 'package:E_louma/Pages/Settings/dashboardPage.dart';
import 'package:E_louma/Pages/Auth/signIn.dart';
import 'package:E_louma/Utils/size.dart';
import 'package:E_louma/Pages/seller/seller_catalog_page.dart';
import 'package:E_louma/widget/add_product.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  bool savedConnexion = false;

  String token = "";

  _readToken() async {
    final prefs = await SharedPreferences.getInstance();

    var tokenValue = prefs.getString('token') ?? "";
    setState(() {
      token = tokenValue;
    });
  }

  List<ProductInterface> _filtered = [];
  List<CategoryInterface> listCat = [];
  List<ProductInterface> listProduct = [];
  List<ProductInterface> listMyProduct = [];
  List<CategoryInterface> listCatFilter = [];
  List<ProductInterface> listProductFilter = [];
  List<String> listNameCat = [];
  bool showShimmers = true;
  bool _showMyProductsOnly = false;
  String? _selectedCategoryId;

  void _applyFilters() {
    final source = _showMyProductsOnly ? listMyProduct : listProduct;
    setState(() {
      _filtered = ProductService.filterProducts(
        products: source,
        categoryId: _selectedCategoryId,
      );
    });
  }

  void _setProductScope(bool myProductsOnly) {
    setState(() {
      _showMyProductsOnly = myProductsOnly;
    });
    _applyFilters();
  }

  void _setCategoryFilter(String? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    if (!_showMyProductsOnly) {
      _fetchProducts(categoryId: categoryId);
    } else {
      _applyFilters();
    }
  }

  void _resetFilters() {
    setState(() {
      _showMyProductsOnly = false;
      _selectedCategoryId = null;
    });
    _fetchProducts();
  }

  filteredProduct(String _searchCtrl) {
    final source = _showMyProductsOnly ? listMyProduct : listProduct;
    setState(() {
      _filtered = ProductService.filterProducts(
        products: source,
        categoryId: _selectedCategoryId,
        searchQuery: _searchCtrl,
      );
    });
  }

  _fetchCategory() async {
    try {
      await ProductService().fetchCategory().then((value) {
        setState(() {
          print("values $value");
          listCat = value;

          showShimmers = false;
        });
      });
    } catch (e) {}
  }

  _fetchProducts({String? categoryId}) async {
    try {
      await ProductService()
          .fetchProducts(categoryId: categoryId, limit: 50)
          .then((value) {
        setState(() {
          print("values $value");
          listProduct = value;
          _applyFilters();
          showShimmers = false;
        });
      });
    } catch (e) {
      print("error $e");
    }
  }

  _filterMyCategory() {
    listCatFilter = [];
    setState(() {
      listNameCat = listMyProduct
          .map((product) => product.category.name)
          .toSet()
          .toList();

      listCatFilter =
          listCat.where((cat) => listNameCat.contains(cat.name)).toList();
    });
  }

  _fetchMyProducts() async {
    try {
      await ProductService().fetchMyProducts().then((value) {
        setState(() {
          print("values $value");
          listMyProduct = value;
          if (_showMyProductsOnly) {
            _applyFilters();
          }
          _filterMyCategory();
          showShimmers = false;
        });
      });
    } catch (e) {
      print("error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _readToken();
    _fetchCategory();
    _fetchProducts();
    _fetchMyProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            margin: const EdgeInsets.all(20),
            width: mediaWidth(context) / 1.5,
            decoration: BoxDecoration(
              color: Color.fromARGB(209, 0, 0, 0),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                // mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SellerCatalogPage(
                                      listCat: listCat,
                                      listProduct: listProduct,
                                    )));
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
                                builder: (context) => AddProductPage(
                                      listCategory: listCat,
                                    )));
                      },
                      child: Container(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReservationsListPage(
                                isCommingSeller: true),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 0),
                        height: 55,
                        width: 40,
                        child: Center(
                            child: Icon(
                          Icons.inventory_2_outlined,
                          color: primaryColor,
                        )),
                      )),
                  GestureDetector(
                      onTap: () {
                        if (token.isEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                          return;
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DashboardPage()));
                        }
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
                                      Icons.notifications,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationsPage()));
                                    },
                                  )),
                              FadeInUp(
                                  duration: Duration(milliseconds: 1300),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SellerCatalogPage(
                                            listCat: listCat,
                                            listProduct: listProduct,
                                          ),
                                        ),
                                      );
                                    },
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
                                                          SellerCatalogPage(
                                                            listCat: listCat,
                                                            listProduct:
                                                                listProduct,
                                                          )));
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
                      (listCatFilter.isEmpty)
                          ? Container()
                          : Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Mes articles",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _setProductScope(true);
                                      _setCategoryFilter(null);
                                    },
                                    child: Text(
                                      "Tout",
                                      style: TextStyle(
                                        color: _showMyProductsOnly &&
                                                _selectedCategoryId == null
                                            ? primaryColor
                                            : Colors.black54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
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
                                    for (var element in listCatFilter)
                                      showShimmers
                                          ? ShimmersPage().statShimmer()
                                          : makeBestCategory(
                                              element,
                                              listMyProduct.length,
                                              context,
                                              listMyProduct,
                                              true),
                                  ],
                                ),
                              ),
                            ]),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Catégories",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              _setProductScope(false);
                              _setCategoryFilter(null);
                            },
                            child: Text(
                              "Tout",
                              style: TextStyle(
                                color: !_showMyProductsOnly &&
                                        _selectedCategoryId == null
                                    ? primaryColor
                                    : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
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
                            for (var element in listCat)
                              showShimmers
                                  ? ShimmersPage().statShimmer()
                                  : makeCategory(element, context, listProduct),
                          ],
                        ),
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 16, 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _showMyProductsOnly
                                      ? 'Mes produits (${_filtered.length})'
                                      : 'Nouveau produits (${_filtered.length})',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_showMyProductsOnly ||
                                    _selectedCategoryId != null)
                                  TextButton(
                                    onPressed: _resetFilters,
                                    child: const Text(
                                      'Réinitialiser',
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: const Text('Tous les produits'),
                                selected: !_showMyProductsOnly,
                                onSelected: (_) => _setProductScope(false),
                                selectedColor:
                                    primaryColor.withValues(alpha: 0.35),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: const Text('Mes produits'),
                                selected: _showMyProductsOnly,
                                onSelected: (_) => _setProductScope(true),
                                selectedColor:
                                    primaryColor.withValues(alpha: 0.35),
                              ),
                            ),
                            ...listCat.map((category) {
                              final selected =
                                  _selectedCategoryId == category.id;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(category.name),
                                  selected: selected,
                                  onSelected: (_) {
                                    if (selected) {
                                      _setCategoryFilter(null);
                                    } else {
                                      _setCategoryFilter(category.id);
                                    }
                                  },
                                  selectedColor:
                                      primaryColor.withValues(alpha: 0.35),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 20),
                          height: mediaHeight(context) / 2,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              child: _filtered.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Aucun produit pour ce filtre.',
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                    )
                                  : FadeInUp(
                                      duration: Duration(milliseconds: 1000),
                                      child: GridView.builder(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 16, 100),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 12,
                                          crossAxisSpacing: 12,
                                          childAspectRatio: 0.72,
                                        ),
                                        itemCount: _filtered.length,
                                        itemBuilder: (context, i) {
                                          final p = _filtered[i];
                                          return makeProductSeller(
                                              detailProduct: p);
                                        },
                                      ),
                                    ))),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget makeProductSeller({required ProductInterface detailProduct}) {
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
