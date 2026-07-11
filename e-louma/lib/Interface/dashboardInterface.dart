import 'dart:ffi';

import 'package:E_louma/Interface/productInterface.dart';

class DashboardInterface {
  SellerInterface? seller;
  StatsInterface? stats;
  List<ProductInterface> recentReservations;
  List<ProductInterface> topProductsByViews;
  List<ProductInterface> topProductsByReservations;
  List<MonthlyTrendInterface> monthlyTrendInterface;

  DashboardInterface({
    required this.seller,
    required this.stats,
    required this.recentReservations,
    required this.topProductsByViews,
    required this.topProductsByReservations,
    required this.monthlyTrendInterface,
  });

  factory DashboardInterface.fromJSON(Map<String, dynamic> json) {
    return DashboardInterface(
      seller: SellerInterface.fromJSON(json['seller']),
      stats: StatsInterface.fromJSON(json['stats']),
      recentReservations: new List<ProductInterface>.from(
          json['recentReservations'].map((x) => ProductInterface.fromJSON(x))),
      topProductsByViews: new List<ProductInterface>.from(
          json['topProductsByViews'].map((x) => ProductInterface.fromJSON(x))),
      topProductsByReservations: new List<ProductInterface>.from(
          json['topProductsByReservations']
              .map((x) => ProductInterface.fromJSON(x))),
      monthlyTrendInterface: new List<MonthlyTrendInterface>.from(
          json['monthlyTrend'].map((x) => MonthlyTrendInterface.fromJSON(x))),
    );
  }
}

class SellerInterface {
  final String id;
  final String fullname;
  final String email;
  final String phonenumber;
  final String role;
  final bool isVerified;

  SellerInterface({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phonenumber,
    required this.role,
    required this.isVerified,
  });

  factory SellerInterface.fromJSON(Map<String, dynamic> json) {
    return SellerInterface(
      id: json['_id'] ?? "",
      fullname: json['fullname'] ?? "",
      email: json['email'] ?? "",
      phonenumber: json['phonenumber'] ?? "",
      role: json['role'] ?? "",
      isVerified: json['isVerified'] ?? false,
    );
  }
}

class StatsInterface {
  final int totalProducts;
  final int totalAvailable;
  final int totalReserved;
  final int totalSold;
  final int totalReservations;
  final int totalRevenue;
  final int totalViews;
  final int totalFavorites;

  StatsInterface({
    required this.totalProducts,
    required this.totalAvailable,
    required this.totalReserved,
    required this.totalSold,
    required this.totalReservations,
    required this.totalRevenue,
    required this.totalViews,
    required this.totalFavorites,
  });

  factory StatsInterface.fromJSON(Map<String, dynamic> json) {
    return StatsInterface(
      totalProducts: json['totalProducts'] ?? 0,
      totalAvailable: json['totalAvailable'] ?? 0,
      totalReserved: json['totalReserved'] ?? 0,
      totalSold: json['totalSold'] ?? 0,
      totalReservations: json['totalReservations'] ?? 0,
      totalRevenue: json['totalRevenue'] ?? 0,
      totalViews: json['totalViews'] ?? 0,
      totalFavorites: json['totalFavorites'] ?? 0,
    );
  }
}

class MonthlyTrendInterface {
  final int year;
  final int month;
  final String label;
  final int reservations;
  final int revenue;

  MonthlyTrendInterface({
    required this.year,
    required this.month,
    required this.label,
    required this.reservations,
    required this.revenue,
  });

  factory MonthlyTrendInterface.fromJSON(Map<String, dynamic> json) {
    return MonthlyTrendInterface(
      year: json['year'] ?? 0,
      month: json['month'] ?? 0,
      label: json['label'] ?? "",
      reservations: json['reservations'] ?? 0,
      revenue: json['revenue'] ?? 0,
    );
  }
}
