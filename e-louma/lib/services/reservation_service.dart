import 'dart:convert';
import 'dart:io';

import 'package:E_louma/Interface/categoryInterface.dart';
import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Utils/network.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Réservation produit avec coordonnées client (stockage local / cache).
class ProductReservation {
  final String productName;
  final String price;
  final String image;
  final String category;
  final String fullName;
  final String phone;
  final String? email;
  final String? phoneNumberSeller;
  final String? note;
  final DateTime createdAt;

  ProductReservation({
    required this.productName,
    required this.price,
    required this.image,
    required this.category,
    required this.fullName,
    required this.phone,
    this.email,
    this.note,
    required this.createdAt,
    required this.phoneNumberSeller,
  });

  Map<String, dynamic> toMap() => {
        'productName': productName,
        'price': price,
        'image': image,
        'category': category,
        'fullName': fullName,
        'phone': phone,
        'email': email,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
        'phoneNumberSeller': phoneNumberSeller
      };

  factory ProductReservation.fromMap(Map<String, dynamic> m) =>
      ProductReservation(
        productName: m['productName'] as String? ?? '',
        price: m['price'] as String? ?? '',
        image: m['image'] as String? ?? '',
        category: m['category'] as String? ?? '',
        fullName: m['fullName'] as String? ?? '',
        phone: m['phone'] as String? ?? '',
        email: m['email'] as String?,
        note: m['note'] as String?,
        phoneNumberSeller: m["phoneNumberSeller"] as String?,
        createdAt: DateTime.tryParse(m['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );

  /// Migrer une entrée issue de l’ancien format « intérêt ».
  factory ProductReservation.fromLegacyInterestMap(Map<String, dynamic> m) {
    final note = m['note'] as String?;
    final desc = note != null && note.isNotEmpty
        ? 'Ancienne demande d’intérêt : $note'
        : '(Importé depuis une ancienne sauvegarde)';
    return ProductReservation(
      productName: m['productName'] as String? ?? '',
      price: m['price'] as String? ?? '',
      image: m['image'] as String? ?? '',
      category: m['category'] as String? ?? '',
      fullName: '—',
      phone: '—',
      email: null,
      note: desc,
      createdAt:
          DateTime.tryParse(m['createdAt'] as String? ?? '') ?? DateTime.now(),
      phoneNumberSeller: m["phoneNumberSeller"],
    );
  }
}

class ReservationService {
  ReservationService._();
  static const _storageKey = 'product_reservations_v1_json';
  static const _legacyKey = 'interest_orders_json';
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

  static Future<List<ProductReservation>> list() async {
    final prefs = await SharedPreferences.getInstance();
    var raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      await _migrateLegacyIfNeeded(prefs);
      raw = prefs.getString(_storageKey);
    }
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => ProductReservation.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> _migrateLegacyIfNeeded(SharedPreferences prefs) async {
    final leg = prefs.getString(_legacyKey);
    if (leg == null || leg.isEmpty) return;
    try {
      final list = jsonDecode(leg) as List<dynamic>;
      final migrated = list
          .map((e) => ProductReservation.fromLegacyInterestMap(
              e as Map<String, dynamic>))
          .map((r) => r.toMap())
          .toList();
      await prefs.setString(_storageKey, jsonEncode(migrated));
    } catch (_) {
      /* ignore */
    }
    await prefs.remove(_legacyKey);
  }

  static Future<void> addReservation({
    required Product product,
    required String fullName,
    required String phone,
    required String phoneNumberSeller,
    String? email,
    String? note,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await list();
    existing.insert(
      0,
      ProductReservation(
        productName: product.name,
        price: product.price,
        image: product.image,
        category: product.category,
        fullName: fullName.trim(),
        phone: phone.trim(),
        email: (email == null || email.trim().isEmpty) ? null : email.trim(),
        note: (note == null || note.trim().isEmpty) ? null : note.trim(),
        createdAt: DateTime.now(),
        phoneNumberSeller: phoneNumberSeller,
      ),
    );
    await prefs.setString(
      _storageKey,
      jsonEncode(existing.map((e) => e.toMap()).toList(growable: false)),
    );
  }

  static Future<void> removeAt(int index) async {
    final existing = await list();
    if (index < 0 || index >= existing.length) return;
    existing.removeAt(index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(existing.map((e) => e.toMap()).toList()),
    );
  }

  static const _contactKey = 'reservation_contact_v1';

  static Future<Map<String, String>> loadSavedContact() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_contactKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  static Future<void> saveContact({
    required String fullName,
    required String email,
    required String phone,
    String? address,
    String? dialCode,
    String? countryName,
    String? isoCode,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _contactKey,
      jsonEncode({
        'fullName': fullName.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        if (address != null && address.trim().isNotEmpty)
          'address': address.trim(),
        if (dialCode != null && dialCode.trim().isNotEmpty)
          'dialCode': dialCode.trim(),
        if (countryName != null && countryName.trim().isNotEmpty)
          'countryName': countryName.trim(),
        if (isoCode != null && isoCode.trim().isNotEmpty)
          'isoCode': isoCode.trim(),
      }),
    );
  }

  static Future<void> cacheReservation({
    required ProductInterface product,
    required String fullName,
    required String phone,
    required String phoneNumberSeller,
    String? email,
    String? note,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await list();
    existing.insert(
      0,
      ProductReservation(
        productName: product.title,
        price: '${product.price} XOF',
        image: product.primaryImageUrl,
        category: product.category.name,
        fullName: fullName.trim(),
        phone: phone.trim(),
        email: (email == null || email.trim().isEmpty) ? null : email.trim(),
        note: (note == null || note.trim().isEmpty) ? null : note.trim(),
        createdAt: DateTime.now(),
        phoneNumberSeller: phoneNumberSeller,
      ),
    );
    await prefs.setString(
      _storageKey,
      jsonEncode(existing.map((e) => e.toMap()).toList(growable: false)),
    );
  }

  static Future<String> submitReservation({
    required String fullname,
    required String email,
    required String phonenumber,
    required String address,
    required String productId,
    required int price,
    required String quantity,
    String? userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    if (token.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    final payload = <String, dynamic>{
      'fullname': fullname.trim(),
      'email': email.trim(),
      'phonenumber': phonenumber.trim(),
      'address': address.trim(),
      'product': productId,
      'price': price,
      'quantity': quantity.trim(),
    };
    if (userId != null && userId.isNotEmpty) {
      payload['user'] = userId;
    }

    print("payload reserv ${jsonEncode(payload)}");
    final response = await http.post(
      Uri.parse('$apiUrl/reservation/add'),
      headers: headers,
      body: jsonEncode(payload),
    );
    print("response.statusCode reserv ${response.statusCode}");
    print("response.body reserv ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data is Map && data['message'] is String) {
        return data['message'] as String;
      }
      return 'Réservation enregistrée avec succès';
    }

    try {
      final errorJson = jsonDecode(response.body);
      final errorMessage = errorJson['message'];
      throw Exception(errorMessage ?? 'Impossible de créer la réservation');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Impossible de créer la réservation');
    }
  }
}
