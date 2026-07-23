import 'package:E_louma/Interface/dashboardInterface.dart';
import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Pages/Settings/profile.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/services/product_service.dart';
import 'package:E_louma/widget/shimmersAnimation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardInterface? infoDash;
  bool isLoadingStats = true;
  _fetchInfoDashBoard() async {
    try {
      await ProductService().fetchMyDashboard().then((value) {
        setState(() {
          print("Result dashboad  $value");
          infoDash = value;
          isLoadingStats = false;
        });
      });
    } catch (err) {
      print("error $err");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchInfoDashBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text("Tableau de bord",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            tooltip: 'Voir la boutique',
            onPressed: () {
              if (infoDash != null)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(seller: infoDash?.seller)),
                );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            /// 🔥 KPI CARDS
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                      child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: isLoadingStats
                        ? ShimmersPage().statShimmer()
                        : _statCard(
                            title: "Revenus",
                            value: "${infoDash?.stats?.totalRevenue} FCFA",
                            icon: Icons.payments,
                            color: Colors.deepPurple,
                          ),
                  )),
                  const SizedBox(width: 15),
                  Expanded(
                      child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: isLoadingStats
                        ? ShimmersPage().statShimmer()
                        : _statCard(
                            title: "Ventes",
                            value: "${infoDash?.stats?.totalSold}",
                            icon: Icons.shopping_cart,
                            color: Colors.green,
                          ),
                  )),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                      child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: isLoadingStats
                        ? ShimmersPage().statShimmer()
                        : _statCard(
                            title: "Reservations",
                            value: "${infoDash?.stats?.totalReservations}",
                            icon: Icons.people,
                            color: Colors.orange,
                          ),
                  )),
                  const SizedBox(width: 15),
                  Expanded(
                      child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: isLoadingStats
                        ? ShimmersPage().statShimmer()
                        : _statCard(
                            title: "Produits",
                            value: "${infoDash?.stats?.totalProducts}",
                            icon: Icons.inventory_2,
                            color: Colors.blue,
                          ),
                  )),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Évolution des revenues",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 280,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: (infoDash != null)
                    ? LineChart(mainData(infoDash!.monthlyTrendInterface))
                    : Container(),
              ).animate().fade().slideY(),
            ]),

            const SizedBox(height: 20),

            /// 🏆 TOP PRODUITS
            ///
            if (infoDash != null)
              Column(children: [
                (infoDash!.topProductsByReservations.length > 0)
                    ? buildSectionTitle("Top Produits")
                    : Container(),
                const SizedBox(height: 10),

                for (var item in infoDash!.topProductsByReservations)
                  buildProductItem(item),
                // buildProductItem("Sac à dos", "30 ventes", "80 000 FCFA"),

                const SizedBox(height: 20),
              ]),

            /// 📜 HISTORIQUE
            if (infoDash != null)
              Column(
                children: [
                  (infoDash!.topProductsByReservations.length > 0)
                      ? buildSectionTitle("Historique des ventes")
                      : Container(),
                  const SizedBox(height: 10),
                  // if (infoDash != null)
                  for (var item in infoDash!.topProductsByViews)
                    buildProductItem(item),

                  const SizedBox(height: 15),
                ],
              ),
          ])),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.30),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white24,
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              const Icon(
                Icons.trending_up,
                color: Colors.white70,
              )
            ],
          ),
          const SizedBox(height: 24),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate().fade().slideY();
  }

  /// GRAPH DATA
  LineChartData mainData(List<MonthlyTrendInterface> monthlyChart) {
    final last6Months = monthlyChart.length <= 5
        ? monthlyChart
        : monthlyChart.sublist(monthlyChart.length - 7);
    final spots = last6Months.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        (entry.value.revenue / 1000 as num).toDouble(),
      );
    }).toList();

    return LineChartData(
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              print("metaaa ${meta.max}");
              if (index < 0 || index >= last6Months.length) {
                return const SizedBox();
              }

              return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    last6Months[index].label.substring(0, 4),
                    style: const TextStyle(fontSize: 10),
                  ));
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTitlesWidget: (value, meta) {
              return Text(
                "${value.toInt()} k",
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 900,
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          barWidth: 5,
          color: primaryColor,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(.35),
                primaryColor.withOpacity(.02),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          spots: spots,
        )
        // LineChartBarData(
        //   spots: spots,
        //   isCurved: true,
        //   barWidth: 4,
        //   dotData: const FlDotData(show: false),
        //   belowBarData: BarAreaData(
        //     show: true,
        //   ),
        // ),
      ],
    );
  }

  Widget buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title,
          style:
              GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget buildProductItem(ProductDashboardInterface product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.shopping_bag)),
        title: Text(product.title),
        subtitle: Text(product.category.name),
        trailing: Text("${product.price} FCFA",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  Widget buildHistoryItem(String product, String price, String date) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(product),
      subtitle: Text(date),
      trailing: Text(price),
    );
  }
}

/// 🔥 CARD KPI
// class DashboardCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;
//   final Color color;
//   final bool showShimmers;

//   const DashboardCard({
//     super.key,
//     required this.title,
//     required this.value,
//     required this.icon,
//     required this.color,
//     required this.showShimmers,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(right: 8),
//       padding: const EdgeInsets.all(16),
//       width: mediaWidth(context) / 2.5,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color),
//           const SizedBox(height: 10),
//           Text(title),
//           const SizedBox(height: 5),
//           Shimmer(
//               duration: Duration(seconds: 3), //Default value
//               interval:
//                   Duration(seconds: 5), //Default value: Duration(seconds: 0)
//               color: Colors.grey.shade300,
//               colorOpacity: 0.7, //Default value
//               enabled: showShimmers, //Default value
//               direction: ShimmerDirection.fromLTRB(), //Default Value
//               child: Text(value,
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold))),
//         ],
//       ),
//     );
//   }
// }
