import 'package:E_louma/Interface/categoryInterface.dart';
import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Pages/Auth/signIn.dart';
import 'package:E_louma/Pages/Auth/signup_page.dart';
import 'package:E_louma/Pages/client/reservations_list_page.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/Utils/size.dart';
import 'package:E_louma/data/catalog_data.dart';
import 'package:E_louma/services/product_service.dart';
import 'package:E_louma/widget/product_details.dart';
import 'package:E_louma/widget/product_details_page.dart';
import 'package:E_louma/widget/product_details_seller.dart';
import 'package:E_louma/widget/shimmersAnimation.dart';
import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Parcours client : recherche, catégories, sélection mise en avant, grille catalogue.
class ClientDiscoverPage extends StatefulWidget {
  const ClientDiscoverPage({super.key});

  @override
  State<ClientDiscoverPage> createState() => _ClientDiscoverPageState();
}

class _ClientDiscoverPageState extends State<ClientDiscoverPage> {
  final _searchCtrl = TextEditingController();
  String? _categoryFilterId;
  List<CategoryInterface> listCat = [];
  List<ProductInterface> listProduct = [];
  List<ProductInterface> listProductFilter = [];
  bool showShimmers = true;

  void _applyFilters() {
    setState(() {
      _filtered = ProductService.filterProducts(
        products: listProduct,
        categoryId: _categoryFilterId,
        searchQuery:
            _searchCtrl.text.isNotEmpty ? _searchCtrl.text : null,
      );
    });
  }

  List<ProductInterface> _filtered = [];

  filteredProduct(String searchText) {
    _applyFilters();
  }

  List<Product> get _featured {
    final all = CatalogData.allProducts;
    if (all.isEmpty) return [];
    final n = all.length >= 6 ? 6 : all.length;
    return all.take(n).toList(growable: false);
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

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
    _fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Mes réservations',
        elevation: 6,
        backgroundColor: Colors.black87,
        foregroundColor: primaryColor,
        child: const Icon(Icons.event_note_rounded, size: 26),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ReservationsListPage(
                isCommingSeller: false,
              ),
            ),
          );
        },
      ),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(child: _buildTopHeader(context)),
            SliverToBoxAdapter(child: _buildSearchRow()),
            SliverToBoxAdapter(child: _buildCategoryStrip()),
            SliverToBoxAdapter(child: _sectionTitle('Sélection pour vous')),
            SliverToBoxAdapter(
                child: showShimmers
                    ? ShimmersPage().statShimmer()
                    : _buildFeaturedCarousel()),
            SliverToBoxAdapter(
                child: _sectionTitle('Nos produits (${listProduct.length})')),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
              sliver: _filtered.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.search_off_rounded,
                                  size: 56, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Text(
                                'Aucun résultat. Essayez un autre mot-clé.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.68,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final p = _filtered[i];
                          return showShimmers
                              ? ShimmersPage().statShimmer()
                              : makeProductClient(detailProduct: p);
                        },
                        childCount: _filtered.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeProductClient({required ProductInterface detailProduct}) {
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
                                "${detailProduct.price} XOF",
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
            )));
  }

  Widget _buildTopHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 1,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Mes réservations',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 1,
                  shadowColor: Colors.black.withValues(alpha: 0.08),
                  side: BorderSide.none,
                  shape: const CircleBorder(),
                ),
                icon: FadeInUp(
                    duration: Duration(milliseconds: 1400),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: mediaWidth(context) / 2.5,
                        height: 30,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Devenir un vendeur",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14),
                            )),
                      ),
                    )),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              //   decoration: BoxDecoration(
              //     color: primaryColor.withValues(alpha: 0.22),
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Icon(Icons.verified_rounded,
              //           size: 18, color: Colors.grey.shade900),
              //       const SizedBox(width: 6),
              //       Text(
              //         'Seconde main',
              //         style: GoogleFonts.poppins(
              //             fontWeight: FontWeight.w600, fontSize: 12),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Qu’est-ce qui vous fait envie ?',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Parcourez par catégorie ou recherchez un article. Touchez une carte pour tout voir.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _searchCtrl,
        builder: (_, __, ___) {
          return TextField(
            controller: _searchCtrl,
            onChanged: (_) => _applyFilters(),
            decoration: InputDecoration(
              hintText: 'Rechercher robe, lunettes, tech…',
              prefixIcon:
                  Icon(Icons.search_rounded, color: Colors.grey.shade600),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        _searchCtrl.clear();
                        _applyFilters();
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: primaryColor, width: 1.8),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryStrip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Catégories',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 12),
        showShimmers
            ? ShimmersPage().statShimmer()
            : SizedBox(
                height: 104,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _CategoryOrb(
                      label: 'Tout',
                      image: null,
                      selected: _categoryFilterId == null,
                      onTap: () => setState(() {
                        _categoryFilterId = null;
                        _fetchProducts();
                      }),
                    ),
                    ...listCat.map((c) {
                      final sel = _categoryFilterId == c.id;
                      return _CategoryOrb(
                        label: c.name,
                        image: c.image,
                        selected: sel,
                        onTap: () => setState(() {
                          _categoryFilterId = c.id;
                          _fetchProducts(categoryId: c.id);
                        }),
                      );
                    }),
                  ],
                ),
              ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: listProduct.length,
        itemBuilder: (context, i) {
          final p = listProduct[i];
          return Padding(
            padding: const EdgeInsets.only(left: 4, right: 8),
            child: SizedBox(
              width: 170,
              child: makeProductClient(detailProduct: p),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryOrb extends StatelessWidget {
  final String label;
  final String? image;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryOrb({
    required this.label,
    required this.image,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 86,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: selected
                  ? primaryColor.withValues(alpha: 0.28)
                  : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? primaryColor : Colors.grey.shade200,
                width: selected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: image == null
                        ? Icon(Icons.apps_rounded,
                            size: 32, color: Colors.grey.shade700)
                        : Image.network(
                            image!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                                Icons.category_outlined,
                                color: Colors.grey.shade500),
                          ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductInterface product;
  final bool compact;

  const _ProductCard({required this.product, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      elevation: compact ? 2 : 0,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailCustomerPages(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.image[0],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: Icon(Icons.inventory_2_outlined,
                          color: Colors.grey.shade500, size: 40),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.category.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(compact ? 10 : 12, compact ? 8 : 10,
                  compact ? 10 : 12, compact ? 8 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: compact ? 2 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: compact ? 13 : 14,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${product.price} XOF",
                    style: TextStyle(
                      color: const Color(0xFF2E7D32),
                      fontWeight: FontWeight.w800,
                      fontSize: compact ? 13 : 14,
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 4),
                    Text(
                      product.quantity,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
