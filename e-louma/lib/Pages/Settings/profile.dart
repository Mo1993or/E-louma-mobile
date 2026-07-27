import 'package:E_louma/Interface/dashboardInterface.dart';
import 'package:E_louma/Pages/HomePage/Notification.dart';
import 'package:E_louma/Pages/client/client_discover_page.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/services/product_service.dart';
import 'package:E_louma/services/session_service.dart';
import 'package:E_louma/widget/showAlertCustom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final SellerInterface? seller;
  const ProfileScreen({super.key, required this.seller});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _bg = Color(0xFFF8F9FC);

  Future<void> _clearSessionAndLeave() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await SessionService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ClientDiscoverPage()),
      (_) => false,
    );
  }

  void _confirmLogout() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      showConfirmBtn: true,
      showCancelBtn: true,
      confirmBtnText: 'Oui',
      cancelBtnText: 'Non',
      confirmBtnColor: primaryColor,
      title: 'Déconnexion',
      text: 'Êtes-vous sûr de vouloir vous déconnecter ?',
      onConfirmBtnTap: () async {
        Navigator.pop(context);
        await _clearSessionAndLeave();
      },
    );
  }

  void _confirmDelete() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      showConfirmBtn: true,
      showCancelBtn: true,
      confirmBtnText: 'Oui',
      cancelBtnText: 'Non',
      confirmBtnColor: const Color(0xFFC44536),
      title: 'Suppression du compte',
      text: 'Êtes-vous sûr de vouloir supprimer votre compte ?',
      onConfirmBtnTap: () async {
        try {
          Navigator.pop(context);
          showAlertDialog(context);
          await ProductService().deleteAccount();
          await _clearSessionAndLeave();
        } catch (_) {
          if (mounted) Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final seller = widget.seller;
    final name = (seller?.fullname ?? '').trim().isEmpty
        ? 'Utilisateur'
        : seller!.fullname.trim();
    final email = seller?.email ?? '';
    final phone = seller?.phonenumber ?? '';
    final verified = seller?.isVerified == true;

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            elevation: 0,
            backgroundColor: _bg,
            foregroundColor: Colors.black87,
            title: Text(
              'Profil',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(primaryColor,primaryColor, 0.0)!,
                      Color.lerp(primaryColor, primaryColor, 0.0)!,
                      primaryColor,
                    ],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.0),
                              width: 2.5,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage('assets/images/utilisateur.png'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            verified ? 'Compte vérifié' : 'Compte vendeur',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Informations',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProfileCard(
                    children: [
                      _InfoTile(
                        icon: Icons.person_outline_rounded,
                        label: 'Nom complet',
                        value: name,
                      ),
                      const Divider(height: 1),
                      _InfoTile(
                        icon: Icons.email_outlined,
                        label: 'E-mail',
                        value: email.isEmpty ? '—' : email,
                      ),
                      if (phone.isNotEmpty) ...[
                        const Divider(height: 1),
                        _InfoTile(
                          icon: Icons.phone_outlined,
                          label: 'Téléphone',
                          value: phone,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Paramètres',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProfileCard(
                    children: [
                      _ActionTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Voir vos alertes',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _confirmLogout,
                      child: Text(
                        'Se déconnecter',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFC44536),
                        side: const BorderSide(color: Color(0xFFC44536)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _confirmDelete,
                      child: Text(
                        'Supprimer mon compte',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
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

class _ProfileCard extends StatelessWidget {
  final List<Widget> children;

  const _ProfileCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(children: children),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.black87, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.black87, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
