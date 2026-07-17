import 'package:E_louma/Interface/categoryInterface.dart';
import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Pages/Auth/signIn.dart';
import 'package:E_louma/Pages/client/reservations_list_page.dart';
import 'package:E_louma/services/reservation_service.dart';
import 'package:E_louma/widget/showAlertCustom.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Formulaire client : coordonnées + confirmation avant réservation API.
class ReservationFormPage extends StatefulWidget {
  final ProductInterface product;

  const ReservationFormPage({super.key, required this.product});

  @override
  State<ReservationFormPage> createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController(text: '1');
  final _priceCtrl = TextEditingController();

  bool _showConfirmation = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _priceCtrl.text = '${widget.product.price}';
    for (final c in [
      _fullNameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _addressCtrl,
      _quantityCtrl,
      _priceCtrl,
    ]) {
      c.addListener(_onFieldsChanged);
    }
    _loadSavedContact();
  }

  void _onFieldsChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadSavedContact() async {
    final saved = await ReservationService.loadSavedContact();
    if (!mounted) return;
    setState(() {
      if (saved['fullName']?.isNotEmpty == true) {
        _fullNameCtrl.text = saved['fullName']!;
      }
      if (saved['email']?.isNotEmpty == true) {
        _emailCtrl.text = saved['email']!;
      }
      if (saved['phone']?.isNotEmpty == true) {
        _phoneCtrl.text = saved['phone']!;
      }
      if (saved['address']?.isNotEmpty == true) {
        _addressCtrl.text = saved['address']!;
      }
    });
  }

  @override
  void dispose() {
    for (final c in [
      _fullNameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _addressCtrl,
      _quantityCtrl,
      _priceCtrl,
    ]) {
      c.removeListener(_onFieldsChanged);
      c.dispose();
    }
    super.dispose();
  }

  int get _priceValue =>
      int.tryParse(_priceCtrl.text.trim()) ?? widget.product.price;

  bool get _isFormValid {
    final name = _fullNameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final address = _addressCtrl.text.trim();
    final quantity = int.tryParse(_quantityCtrl.text.trim());

    if (name.isEmpty) return false;
    if (email.isEmpty || !email.contains('@')) return false;
    if (phone.length < 9) return false;
    if (address.isEmpty) return false;
    if (quantity == null || quantity < 1) return false;

    if (widget.product.pricenegotiable) {
      if (int.tryParse(_priceCtrl.text.trim()) == null) return false;
    }

    return true;
  }

  void _goToConfirmation() {
    if (!_isFormValid) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _showConfirmation = true);
  }

  Future<void> _submitReservation() async {
    setState(() => _submitting = true);
    showAlertDialog(context);

    try {
      final message = await ReservationService.submitReservation(
        fullname: _fullNameCtrl.text,
        email: _emailCtrl.text,
        phonenumber: _phoneCtrl.text,
        address: _addressCtrl.text,
        productId: widget.product.id,
        price: _priceValue,
        quantity: _quantityCtrl.text,
      );

      await ReservationService.saveContact(
        fullName: _fullNameCtrl.text,
        email: _emailCtrl.text,
        phone: _phoneCtrl.text,
        address: _addressCtrl.text,
      );

      await ReservationService.cacheReservation(
        product: widget.product,
        fullName: _fullNameCtrl.text,
        phone: _phoneCtrl.text,
        email: _emailCtrl.text,
        note: 'Quantité : ${_quantityCtrl.text}',
      );

      if (!mounted) return;
      Navigator.pop(context);

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Réservation confirmée',
          message: message,
          contentType: ContentType.success,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => const ReservationsListPage(
                  isCommingSeller: false,
                )),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Réservation échoué',
          message: "${e.toString().replaceFirst('Exception: ', '')}",
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          _showConfirmation ? 'Confirmation' : 'Réserver',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (_showConfirmation) {
              setState(() => _showConfirmation = false);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: _showConfirmation ? _buildConfirmation() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProductSummary(product: widget.product),
            const SizedBox(height: 24),
            Text(
              'Vos informations',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Le vendeur vous contactera pour finaliser l’achat.',
              style: TextStyle(color: Colors.grey.shade600, height: 1.35),
            ),
            const SizedBox(height: 20),
            CustomInputField(
              labelText: 'Nom complet',
              hintText: 'Ex. Ibrahima Diouf',
              emailCtr: _fullNameCtrl,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
            ),
            const SizedBox(height: 12),
            CustomInputField(
              labelText: 'E-mail',
              hintText: 'Ex. ibrahima@gmail.com',
              emailCtr: _emailCtrl,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'E-mail requis';
                if (!v.contains('@')) return 'E-mail invalide';
                return null;
              },
            ),
            const SizedBox(height: 12),
            CustomInputField(
              labelText: 'Téléphone',
              hintText: 'Ex. 771115241',
              emailCtr: _phoneCtrl,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Téléphone requis';
                if (v.trim().length < 9) return 'Numéro trop court';
                return null;
              },
            ),
            const SizedBox(height: 12),
            CustomInputField(
              labelText: 'Adresse',
              hintText: 'Ex. Dakar, Plateau',
              emailCtr: _addressCtrl,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Adresse requise' : null,
            ),
            const SizedBox(height: 12),
            CustomInputField(
              labelText: 'Quantité',
              hintText: '1',
              emailCtr: _quantityCtrl,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Quantité requise';
                final n = int.tryParse(v.trim());
                if (n == null || n < 1) return 'Quantité invalide';
                return null;
              },
            ),
            if (widget.product.pricenegotiable) ...[
              const SizedBox(height: 12),
              CustomInputField(
                labelText: 'Prix proposé (XOF)',
                hintText: '${widget.product.price}',
                emailCtr: _priceCtrl,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Prix requis';
                  if (int.tryParse(v.trim()) == null) return 'Prix invalide';
                  return null;
                },
              ),
            ] else ...[
              const SizedBox(height: 12),
              _InfoRow(
                label: 'Prix',
                value: '${widget.product.price} XOF',
              ),
            ],
            const SizedBox(height: 32),
            CustomFormButton(
              innerText: 'Continuer',
              onPressed: _isFormValid ? _goToConfirmation : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmation() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProductSummary(product: widget.product),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Récapitulatif',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                _InfoRow(label: 'Nom', value: _fullNameCtrl.text.trim()),
                _InfoRow(label: 'E-mail', value: _emailCtrl.text.trim()),
                _InfoRow(label: 'Téléphone', value: _phoneCtrl.text.trim()),
                _InfoRow(label: 'Adresse', value: _addressCtrl.text.trim()),
                _InfoRow(label: 'Quantité', value: _quantityCtrl.text.trim()),
                _InfoRow(label: 'Prix', value: '$_priceValue XOF'),
                const Divider(height: 28),
                Text(
                  'En confirmant, vous demandez la réservation de cet article. Le vendeur vous recontactera.',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          CustomFormButton(
            innerText: _submitting ? 'Envoi…' : 'Confirmer la réservation',
            onPressed: _submitting ? null : _submitReservation,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _submitting
                ? null
                : () => setState(() => _showConfirmation = false),
            child: Text(
              'Modifier mes informations',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductSummary extends StatelessWidget {
  final ProductInterface product;

  const _ProductSummary({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: product.primaryImageUrl.isNotEmpty
                ? Image.network(
                    product.primaryImageUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.category.name,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.price} XOF',
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 72,
      height: 72,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(Icons.inventory_2_outlined, color: Colors.grey.shade500),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
