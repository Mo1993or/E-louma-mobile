import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/services/reservation_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

/// Carte liste pour une réservation locale (réutilisable profil / liste dédiée).
class ClientReservationCard extends StatelessWidget {
  final ProductReservation reservation;
  final String dateLabel;
  final VoidCallback onDelete;

  const ClientReservationCard({
    super.key,
    required this.reservation,
    required this.dateLabel,
    required this.onDelete,
  });
  Future<void> _makePhoneCall(String phoneNumber) async {
    // Sanitize the number by removing white spaces if any exist
    final String cleanNumber = phoneNumber.replaceAll(' ', '');
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: cleanNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw Exception('Could not launch phone dialer for $cleanNumber');
    }
  }

  _launchWhatsapp(String produit, String tel) async {
    var url =
        "https://wa.me/$tel?text= Bonjour j'ai vu votre produit $produit sur E-LOUMA et ça m'interesse ${produit} ";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _ReservationImage(image: reservation.image),
              ),
              const SizedBox(width: 14),
              // Expanded(
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 25,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                          child: Text(
                        'Réservé',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.delete_outline_rounded,
                          color: const Color.fromARGB(255, 208, 15, 1)),
                      onPressed: onDelete,
                      constraints:
                          const BoxConstraints(minWidth: 40, minHeight: 40),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ])
            ]),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  reservation.productName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${reservation.price} · ${reservation.category}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_outline_rounded,
                              size: 16, color: Colors.grey.shade700),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              reservation.fullName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone_outlined,
                              size: 16, color: Colors.grey.shade700),
                          const SizedBox(width: 6),
                          Text(
                            reservation.phone,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                      if (reservation.email != null &&
                          reservation.email!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.email_outlined,
                                size: 16, color: Colors.grey.shade700),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                reservation.email!,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade800),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (reservation.note != null &&
                    reservation.note!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '« ${reservation.note} »',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded,
                        size: 15, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      dateLabel,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _makePhoneCall(reservation.phoneNumberSeller ?? "");
                      // Navigator.pop(context);

                      /// ACTION COMMANDE
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      // padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      "Appeler le vendeur 📞",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _launchWhatsapp(reservation.productName,
                          reservation.phoneNumberSeller ?? "");
                      Navigator.pop(context);

                      /// ACTION COMMANDE
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      // padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      "Discuter avec le vendeur ✆",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _ReservationImage extends StatelessWidget {
  final String image;

  const _ReservationImage({required this.image});

  bool get _isNetwork =>
      image.startsWith('http://') || image.startsWith('https://');

  Widget _placeholder() {
    return Container(
      width: 86,
      height: 86,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child:
          Icon(Icons.image_not_supported_outlined, color: Colors.grey.shade400),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) return _placeholder();

    if (_isNetwork) {
      return Image.network(
        image,
        width: double.infinity,
        height: 190,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    return Image.asset(
      image,
      width: 86,
      height: 86,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }
}
