import 'package:E_louma/Interface/categoryInterface.dart';
import 'package:E_louma/Interface/productInterface.dart';

/// Catégorie présentée dans la boutique (image + navigation).
class CatalogCategory {
  final String id;
  final String title;
  final String image;
  final String heroTag;

  const CatalogCategory({
    required this.id,
    required this.title,
    required this.image,
    required this.heroTag,
  });
}

/// Données catalogue (démo hors backend) — source unique pour vendeur & co.
class CatalogData {
  CatalogData._();

  static const List<CatalogCategory> categories = [
    CatalogCategory(
      id: 'Tech',
      title: 'Tech',
      image: 'assets/images/tech.jpg',
      heroTag: 'Tech',
    ),
    CatalogCategory(
      id: 'Montre',
      title: 'Montre',
      image: 'assets/images/watch.jpg',
      heroTag: 'Watch',
    ),
    CatalogCategory(
      id: 'Parfum',
      title: 'Parfum',
      image: 'assets/images/perfume.jpg',
      heroTag: 'Perfum',
    ),
    CatalogCategory(
      id: 'Lunettes',
      title: 'Lunettes',
      image: 'assets/images/glass.jpg',
      heroTag: 'Glass',
    ),
    CatalogCategory(
      id: 'Beauté',
      title: 'Beauté',
      image: 'assets/images/beauty.jpg',
      heroTag: 'beauty',
    ),
    CatalogCategory(
      id: 'Vêtements',
      title: 'Vêtements',
      image: 'assets/images/clothes.jpg',
      heroTag: 'clothes',
    ),
    CatalogCategory(
      id: 'Divers',
      title: 'Divers',
      image: 'assets/images/person.jpg',
      heroTag: 'divers',
    ),
  ];

  static final List<Product> allProducts = [
    Product(
      name: 'Écouteurs',
      category: 'Tech',
      price: '35 000 FCFA',
      quality: 'Neuf',
      image: 'assets/images/tech.jpg',
    ),
    Product(
      name: 'Montre classique',
      category: 'Montre',
      price: '42 000 FCFA',
      quality: 'Très bon état',
      image: 'assets/images/watch.jpg',
    ),
    Product(
      name: 'Parfum signature 50ml',
      category: 'Parfum',
      price: '18 500 FCFA',
      quality: 'Neuf',
      image: 'assets/images/perfume.jpg',
    ),
    Product(
      name: 'Lunettes',
      category: 'Lunettes',
      price: '12 000 FCFA',
      quality: 'Bon état',
      image: 'assets/images/glass.jpg',
    ),
    Product(
      name: 'Kit soin visage',
      category: 'Beauté',
      price: '22 000 FCFA',
      quality: 'Neuf',
      image: 'assets/images/beauty-1.jpg',
    ),
    Product(
      name: 'Soin capillaire premium',
      category: 'Beauté',
      price: '15 000 FCFA',
      quality: 'Neuf',
      image: 'assets/images/beauty.jpg',
    ),
    Product(
      name: 'Sweat street',
      category: 'Vêtements',
      price: '10 000 FCFA',
      quality: 'Très bon état',
      image: 'assets/images/clothes-1.jpg',
    ),
    Product(
      name: 'Ensemble casual',
      category: 'Vêtements',
      price: '28 000 FCFA',
      quality: 'Neuf',
      image: 'assets/images/clothes.jpg',
    ),
    Product(
      name: 'Eau de toilette floral',
      category: 'Parfum',
      price: '14 500 FCFA',
      quality: 'Neuf',
      image: 'assets/images/perfume.jpg',
    ),
    Product(
      name: 'Accessoires lifestyle',
      category: 'Divers',
      price: '8 000 FCFA',
      quality: 'Bon état',
      image: 'assets/images/person.jpg',
    ),
  ];
  static List<Product> allProduct() {
    return allProducts.toList();
  }

  static List<Product> productsInCategory(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) {
      return List<Product>.from(allProducts);
    }
    return allProducts.where((p) => p.category == categoryId).toList();
  }

  /// Utilisé par [CategoryPage] : le titre doit correspondre au champ [Product.category].
  static List<Product> productsForCategoryPageTitle(String pageTitle) =>
      productsInCategory(pageTitle);

  static List<ProductInterface> searchProducts(
      String query, List<ProductInterface> pool) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return pool;
    return pool
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.category.name.toLowerCase().contains(q))
        .toList();
  }
}
