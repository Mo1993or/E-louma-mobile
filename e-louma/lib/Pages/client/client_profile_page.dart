import 'package:E_louma/Pages/HomePage/homePage.dart';
import 'package:E_louma/Pages/client/client_discover_page.dart';
import 'package:E_louma/Pages/client/client_reservation_card.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/services/reservation_service.dart';
import 'package:E_louma/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String _formatDateFr(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

/// Espace client enrichi : en-tête, stats, liste des réservations en cache sur l’appareil.
class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  List<ProductReservation> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await ReservationService.list();
    setState(() {
      _orders = list;
      _loading = false;
    });
  }

  Future<void> _logout() async {
    await SessionService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => HomePage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              slivers: [
                SliverAppBar(
                  expandedHeight: 210,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: const Color(0xFFF8F9FC),
                  foregroundColor: Colors.black87,
                  actions: [
                    IconButton(
                      tooltip: 'Actualiser',
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: _load,
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: _HeaderGradient(
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.18),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 42,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 38,
                                    backgroundColor:
                                        primaryColor.withValues(alpha: 0.25),
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 42,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Mon espace',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Vos réservations sur cet appareil',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.92),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -28),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _StatTile(
                                  icon: Icons.event_available_rounded,
                                  label: 'Réservations',
                                  value: '${_orders.length}',
                                  subtitle: 'enregistrées localement',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatTile(
                                  icon: Icons.notifications_active_rounded,
                                  label: 'Statut',
                                  value: 'Actif',
                                  subtitle: 'compte ouvert',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _QuickActions(
                            onDiscover: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ClientDiscoverPage(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mes réservations',
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_orders.isNotEmpty)
                                TextButton.icon(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      builder: (ctx) => Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Comment ça marche ?',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                            const SizedBox(height: 12),
                                            const Text(
                                              'Les réservations sont enregistrées sur ce téléphone (pas besoin d’être connecté). Vous pouvez les supprimer de la liste à tout moment.',
                                              style: TextStyle(height: 1.4),
                                            ),
                                            const SizedBox(height: 16),
                                            SizedBox(
                                              width: double.infinity,
                                              child: FilledButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx),
                                                child: const Text('Compris'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  icon:
                                      const Icon(Icons.help_outline, size: 18),
                                  label: const Text('Aide'),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_orders.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyReservations(
                      onBrowse: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ClientDiscoverPage(),
                          ),
                        );
                      },
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final o = _orders[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: ClientReservationCard(
                              reservation: o,
                              dateLabel: _formatDateFr(o.createdAt),
                              onDelete: () async {
                                await ReservationService.removeAt(i);
                                _load();
                              },
                            ),
                          );
                        },
                        childCount: _orders.length,
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      8,
                      24,
                      32 + MediaQuery.paddingOf(context).bottom,
                    ),
                    child: Column(
                      children: [
                        Divider(color: Colors.grey.shade300),
                        const SizedBox(height: 8),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.logout_rounded,
                              color: Colors.grey.shade700),
                          title: Text('Se déconnecter',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500)),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: _logout,
                        ),
                        Text(
                          'E-louma · Mode démo hors ligne',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _HeaderGradient extends StatelessWidget {
  final Widget child;

  const _HeaderGradient({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.lerp(primaryColor, Colors.black87, 0.35)!,
            Color.lerp(primaryColor, Colors.brown.shade800, 0.2)!,
            Colors.grey.shade900,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 26),
          const SizedBox(height: 10),
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onDiscover;

  const _QuickActions({required this.onDiscover});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: onDiscover,
            icon: const Icon(Icons.explore_rounded),
            label: Text('Explorer la boutique',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}

class _EmptyReservations extends StatelessWidget {
  final VoidCallback onBrowse;

  const _EmptyReservations({required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome_rounded,
              size: 64, color: primaryColor.withValues(alpha: 0.8)),
          const SizedBox(height: 18),
          Text(
            'Aucune réservation pour l’instant',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Ouvrez un article et touchez « Réserver cet article » : indiquez vos coordonnées, sans connexion.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onBrowse,
            style: FilledButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text('Découvrir les articles',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
