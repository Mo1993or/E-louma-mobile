import 'package:E_louma/Interface/categoryInterface.dart';

class ProductInterface {
  final String id;
  final String title;
  final int price;
  final List<dynamic> image;
  final bool pricenegotiable;
  CategoryInterface category;
  final String brand;
  final String quantity;
  final String condition;
  Seller seller;
  final String status;
  final int favoritesCount;
  final int view;
  final int reservations;

  ProductInterface({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.pricenegotiable,
    required this.category,
    required this.brand,
    required this.quantity,
    required this.condition,
    required this.seller,
    required this.status,
    required this.favoritesCount,
    required this.view,
    required this.reservations,
  });

  factory ProductInterface.fromJSON(Map<String, dynamic> json) {
    final rawCategory = json['category'];
    return ProductInterface(
      id: json['_id'] ?? "",
      title: json['title'] ?? "",
      price: json['price'] is int
          ? json['price']
          : int.tryParse('${json['price']}') ?? 0,
      image: json['images'] ?? [],
      pricenegotiable: json['pricenegotiable'] ?? false,
      category: rawCategory is Map<String, dynamic>
          ? CategoryInterface.fromJSON(rawCategory)
          : CategoryInterface(id: '', name: 'Autre', image: ''),
      brand: json['brand'] ?? "",
      quantity: json['quantity'] ?? "",
      condition: json['condition'] ?? "",
      seller: Seller.fromJSON(json['seller']),
      status: json['status'] ?? "",
      favoritesCount: json['favoritesCount'] ?? 0,
      view: json['views'] ?? json['view'] ?? 0,
      reservations: json['reservations'] ?? 0,
    );
  }

  String get primaryImageUrl => image.isNotEmpty ? image.first.toString() : '';
}

class ProductDashboardInterface {
  final String id;
  final String title;
  final int price;
  final List<dynamic> image;
  CategoryInterface category;
  final String status;
  final int favoritesCount;
  final int view;
  final int reservations;

  ProductDashboardInterface({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.status,
    required this.favoritesCount,
    required this.view,
    required this.reservations,
  });

  factory ProductDashboardInterface.fromJSON(Map<String, dynamic> json) {
    final rawCategory = json['category'];
    return ProductDashboardInterface(
      id: json['_id'] ?? "",
      title: json['title'] ?? "",
      price: json['price'] is int
          ? json['price']
          : int.tryParse('${json['price']}') ?? 0,
      image: json['images'] ?? [],
      category: rawCategory is Map<String, dynamic>
          ? CategoryInterface.fromJSON(rawCategory)
          : CategoryInterface(id: '', name: 'Autre', image: ''),
      status: json['status'] ?? "",
      favoritesCount: json['favoritesCount'] ?? 0,
      view: json['views'] ?? json['view'] ?? 0,
      reservations: json['reservations'] ?? 0,
    );
  }

  String get primaryImageUrl => image.isNotEmpty ? image.first.toString() : '';
}

class Product {
  final String name;
  final String category;
  final String price;
  final String quality;
  final String image;

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.quality,
    required this.image,
  });

  factory Product.fromJSON(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? "",
      category: json['category'] ?? "",
      price: json['price'] ?? "",
      quality: json['quality'] ?? "",
      image: json['image'] ?? "",
    );
  }
}

class Seller {
  final String id;
  final String phonenumber;

  Seller({
    required this.id,
    required this.phonenumber,
  });

  factory Seller.fromJSON(Map<String, dynamic> json) {
    return Seller(
      id: json['_id'] ?? "",
      phonenumber: json['phonenumber'] ?? "",
    );
  }
}
