import 'package:E_louma/Interface/categoryInterface.dart';
import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Pages/HomePage/SearchProduct.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/services/product_service.dart';
import 'package:E_louma/widget/CategoryPage.dart';
import 'package:E_louma/widget/product_details.dart';
import 'package:E_louma/widget/product_details_page.dart';
import 'package:E_louma/widget/product_details_seller.dart';
import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_search/voice_search.dart';

/// Vue vendeur : toutes les catégories + tous les produits, filtrage et sélection normale.
class SellerCatalogPage extends StatefulWidget {
  final List<CategoryInterface> listCat;
  final List<ProductInterface> listProduct;
  const SellerCatalogPage(
      {super.key, required this.listCat, required this.listProduct});

  @override
  State<SellerCatalogPage> createState() => _SellerCatalogPageState();
}

class _SellerCatalogPageState extends State<SellerCatalogPage> {
  String? _selectedCategoryId;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = allItems;
    _applyFilters();
  }

  List<ProductInterface> _filtered = [];

  void _applyFilters({String? voiceQuery}) {
    final query = voiceQuery ?? _searchCtrl.text;
    setState(() {
      _filtered = ProductService.filterProducts(
        products: widget.listProduct,
        categoryId: _selectedCategoryId,
        searchQuery: query.isNotEmpty ? query : null,
      );
    });
  }

  filteredProduct(String searchText) {
    _applyFilters();
  }

  List<Product> listProd = [];
  List<String> allItems = [
    'Pomme',
    'Banane',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape'
  ];
  List<String> filteredItems = [];
  bool checkVoice = false;
  void _filterList(String query) {
    setState(() {
      _filtered = _filteredProductsVoice(query).toList();
      print("_filtered $_filtered");
      filteredProduct(query);
      // _filteredProducts;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ProductInterface> _filteredProductsVoice(String query) {
    print("_filtered_filtere query $query");
    if (checkVoice) {
      _applyFilters(voiceQuery: query);
      return _filtered;
    } else {
      _applyFilters();
      return _filtered;
    }
  }

  List<ProductInterface> _filteredMyProduct = [];
  List<ProductInterface> filterMyProduct(String idProduct) {
    _filteredMyProduct = widget.listProduct
        .where((product) => product.seller.id == idProduct)
        .toList();
    return _filteredMyProduct;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FadeInDown(
          duration: Duration(milliseconds: 1400),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            (!checkVoice)
                ? VoiceSearchWidget(
                    localeCode: 'fr_FR', // Set locale for voice recognition
                    // localeCode:
                    //     Locales.ENGLISH_US, // choos locale from defined locale class
                    activeWidgetColor:
                        Colors.green, // Color when widget is active
                    inactiveWidgetColor:
                        primaryColor, // Color when widget is inactive
                    activeIcon: Icons.mic, // Icon when widget is active
                    inactiveIcon: Icons.mic_none,
                    // Icon when widget is inactive
                    maxRadius: 35, // Maximum radius of the widget
                    minRadius: 25, // Minimum radius of the widget
                    animationDuration:
                        Duration(milliseconds: 500), // Animation duration
                    animationCurve: Curves.bounceIn, // Animation curve
                    onResult: _filteredProductsVoice,
                    onListeningStarted: () {
                      print('Listening started');
                      checkVoice = true;
                    },
                    onListeningStopped: () {
                      // checkVoice = false;
                      print('Listening stopped');
                    },
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        checkVoice = false;
                        _filteredProductsVoice("");
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Center(
                          child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      )),
                    ))
          ])),
      appBar: AppBar(
        title: Text(
          'Catalogue',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInUp(
              duration: Duration(milliseconds: 1400),
              child: Container(
                margin: EdgeInsets.all(20),
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
                  controller: _searchCtrl,
                  onChanged: (value) {
                    filteredProduct(value);
                  },
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
                    hintText: 'Rechercher un produit ou une catégorie…',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              )),
          // FadeInUp(
          //     duration: Duration(milliseconds: 1000),
          //     child: Padding(
          //       padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          //       child: TextField(
          //         controller: _searchCtrl,
          //         onChanged: (_) => setState(() {}),
          //         decoration: InputDecoration(
          //           hintText: 'Rechercher un produit ou une catégorie…',
          //           prefixIcon: const Icon(Icons.search),
          //           filled: true,
          //           fillColor: Colors.white,
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(14),
          //             borderSide: BorderSide.none,
          //           ),
          //         ),
          //       ),
          //     )),
          FadeInUp(
              duration: Duration(milliseconds: 1000),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  'Catégories',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          FadeInUp(
              duration: Duration(milliseconds: 1000),
              child: SizedBox(
                height: 108,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 8),
                      child: _CategoryChip(
                        label: 'Toutes',
                        selected: _selectedCategoryId == null,
                        onTap: () => setState(() {
                          _selectedCategoryId = null;
                          _applyFilters();
                        }),
                      ),
                    ),
                    ...widget.listCat.map((c) {
                      final selected = _selectedCategoryId == c.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8, bottom: 8),
                        child: _CategoryCard(
                          category: c,
                          selected: selected,
                          onTap: () => setState(() {
                            _selectedCategoryId = c.id;
                            _applyFilters();
                          }),
                        ),
                      );
                    }),
                  ],
                ),
              )),
          FadeInUp(
              duration: Duration(milliseconds: 1000),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Produits (${_filtered.length})',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_selectedCategoryId != null)
                      TextButton(
                        onPressed: () => setState(() {
                          _selectedCategoryId = null;
                          _applyFilters();
                        }),
                        child: const Text(
                          'Réinitialiser filtre',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                  ],
                ),
              )),
          Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Aucun produit pour ce filtre.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  : FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
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
                          return makeProductSeller(detailProduct: p);
                        },
                      ),
                    )),
        ],
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
                      listProduct: filterMyProduct(detailProduct.seller.id),
                    ),
                  ),
                );
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

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: primaryColor.withValues(alpha: 0.35),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: selected ? Colors.black : Colors.black87,
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryInterface category;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? primaryColor : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              category.image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: Colors.grey.shade300),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
              child: Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
