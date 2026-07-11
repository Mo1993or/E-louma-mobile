import 'package:E_louma/Pages/HomePage/ShopPage.dart';
import 'package:E_louma/Pages/client/client_discover_page.dart';
import 'package:E_louma/Pages/client/client_reservation_card.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/services/reservation_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String _formatDateFr(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

/// Liste des réservations en cache (sans connexion requise).
class ReservationsListPage extends StatefulWidget {
  final bool isCommingSeller;
  const ReservationsListPage({super.key, required this.isCommingSeller});

  @override
  State<ReservationsListPage> createState() => _ReservationsListPageState();
}

class _ReservationsListPageState extends State<ReservationsListPage> {
  List<ProductReservation> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await ReservationService.list();
    setState(() {
      _items = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text(
          'Mes réservations',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Actualiser',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () async {
              setState(() => _loading = true);
              await _load();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? _EmptyState(
                  onBrowse: () {
                    if (widget.isCommingSeller) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShopPage(),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ClientDiscoverPage(),
                        ),
                      );
                    }
                  },
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    itemCount: _items.length,
                    itemBuilder: (context, i) {
                      final r = _items[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: ClientReservationCard(
                          reservation: r,
                          dateLabel: _formatDateFr(r.createdAt),
                          onDelete: () async {
                            await ReservationService.removeAt(i);
                            _load();
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onBrowse;

  const _EmptyState({required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available_rounded,
                size: 72, color: primaryColor.withValues(alpha: 0.85)),
            const SizedBox(height: 20),
            Text(
              'Aucune réservation',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Réservez un article depuis sa fiche : vos coordonnées sont enregistrées sur cet appareil.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: onBrowse,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black87,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text('Parcourir le catalogue',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
