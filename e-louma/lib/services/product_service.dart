import 'dart:convert';
import 'dart:io';

import 'package:E_louma/Interface/categoryInterface.dart';
import 'package:E_louma/Interface/dashboardInterface.dart';
import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Utils/network.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  static String token = "";

  static _readToken() async {
    final prefs = await SharedPreferences.getInstance();

    var tokenValue = prefs.getString('token') ?? "";

    token = tokenValue;
  }

  _headersAuth(String tokens) async {
    var headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $tokens"
    };
    return headers;
  }

  Future<List<CategoryInterface>> fetchCategory() async {
    final response = await http.get(
      Uri.parse('$apiUrl/categories'),
    );
    print("response.statusCode oo  ${response.statusCode}");
    print("response.statusCode oo  ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      var listCat = List<CategoryInterface>.from(
          jsonData.map((x) => CategoryInterface.fromJSON(x)));
      print("listCat $listCat");
      return listCat;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = errorJson['message'];
      throw Exception(errorMessage);
    }
  }

  Future<List<ReservationInterface>> fetchReservation(String idProduct) async {
    await _readToken();

    var response = await http.get(
        Uri.parse('$apiUrl/reservation/product/$idProduct'),
        headers: await _headersAuth(token));

    print("response.statusCode rr  ${response.statusCode}");
    print("response.statusCode rr  ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("list ReservationInterface $jsonData");

      var listReserv = List<ReservationInterface>.from(
          jsonData.map((x) => ReservationInterface.fromJSON(x)));
      print("listReserv $listReserv");
      return listReserv;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = errorJson['message'];
      throw Exception(errorMessage);
    }
  }

  dynamic addProduct(
    product,
    List<dynamic> data,
  ) async {
    print("request.body  product${product}");
    await _readToken();

    final String url = '$apiUrl/products/add';

    var request = http.MultipartRequest("POST", Uri.parse(url));
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    request.fields['title'] = product["title"];
    request.fields['price'] = "${product['price']}";
    request.fields['category'] = product["category"];
    request.fields['brand'] = product["brand"];
    request.fields['quantity'] = product["quantity"];
    request.fields['condition'] = product["condition"].toString().toLowerCase();
    request.fields['status'] = "disponible";
    request.fields['pricenegotiable'] = "${product['pricenegotiable']}";
    if (data.isNotEmpty) {
      for (var element in data) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "images",
            element,
            filename: "product",
            contentType: MediaType('image', 'png'),
          ),
        );
      }
    }
    request.headers.addAll(headers);

    var resp = await request.send();
    var response = await http.Response.fromStream(resp);
    print("response.statusCode ${response.statusCode}");
    print("response.body ${response.body}");
    if (response.statusCode == 201) {
      return 'La commande a été mise à jour avec succès';
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = errorJson['message'];
      throw Exception(errorMessage);
    }
  }

  static List<ProductInterface> filterProducts({
    required List<ProductInterface> products,
    String? categoryId,
    String? searchQuery,
  }) {
    return products.where((product) {
      if (categoryId != null && categoryId.isNotEmpty) {
        final matchesCategory = product.category.id == categoryId ||
            product.category.name == categoryId;
        if (!matchesCategory) return false;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final matchesTitle = product.title.toLowerCase().contains(query);
        final matchesCategoryName =
            product.category.name.toLowerCase().contains(query);
        if (!matchesTitle && !matchesCategoryName) return false;
      }
      return true;
    }).toList();
  }

  Future<List<ProductInterface>> fetchProducts({
    int limit = 20,
    String? categoryId,
  }) async {
    final queryParams = <String, String>{'limit': '$limit'};
    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['category'] = categoryId;
    }
    final response = await http.get(
      Uri.parse('$apiUrl/products/index').replace(queryParameters: queryParams),
    );
    print("response.statusCode oo  ${response.statusCode}");
    print("response.statusCode oo  ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("listProduct ${jsonData["products"]}");
      final listProducts = <ProductInterface>[];
      for (final item in jsonData["products"] as List) {
        try {
          listProducts.add(ProductInterface.fromJSON(item));
        } catch (e) {
          print("Skip invalid product: $e");
        }
      }
      print("listProducts $listProducts");
      if (categoryId != null && categoryId.isNotEmpty) {
        return filterProducts(products: listProducts, categoryId: categoryId);
      }
      return listProducts;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = errorJson['message'];
      throw Exception(errorMessage);
    }
  }

  Future<List<ProductInterface>> fetchMyProducts() async {
    await _readToken();
    final response = await http.get(Uri.parse('$apiUrl/products/me'),
        headers: await _headersAuth(token));
    print("response.statusCode oo  ${response.statusCode}");
    print("response.statusCode oo  ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("listProductsss $jsonData");
      final listProducts = <ProductInterface>[];
      for (final item in jsonData as List) {
        try {
          listProducts.add(ProductInterface.fromJSON(item));
        } catch (e) {
          print("Skip invalid product: $e");
        }
      }
      print("listProductss $listProducts");
      return listProducts;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = errorJson['message'];
      throw Exception(errorMessage);
    }
  }

  Future<DashboardInterface> fetchMyDashboard() async {
    await _readToken();
    final response = await http.get(Uri.parse('$apiUrl/dashboard'),
        headers: await _headersAuth(token));
    print("response.statusCode oo  ${response.statusCode}");
    print("response.statusCode oo  ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("listProductsss $jsonData");
      DashboardInterface dashboardPa = DashboardInterface.fromJSON(jsonData);

      print("dashboardPa $dashboardPa");
      return dashboardPa;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = errorJson['message'];
      throw Exception(errorMessage);
    }
  }

  validateRservation(var data) async {
    await _readToken();
    print("data.toString()  ${data.toString()}");
    final response = await http.post(
      Uri.parse('$apiUrl/reservation/validate'),
      headers: await _headersAuth(token),
      body: json.encode(data),
    );
    print("response.statusCode oo  ${response.statusCode}");
    print("response.statusCode oo  ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body);

      print("dashboardPa $jsonData");
      return jsonData;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = errorJson['message'];
      throw Exception(errorMessage);
    }
  }

  dynamic deleteAccount() async {
    await _readToken();
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/delete-account'),
        headers: await _headersAuth(token),
      );
      print('response.body dd : ${response.body}');
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseData;
      } else {
        final errorMessage = responseData['message'];
        throw Exception('$errorMessage');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
